import 'dart:io';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/upload_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class EditProductViewModel extends BaseViewModel {
  final _sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('Edit Color:');

  List<PColor> get colors => _sharedStateService.colors;
  ImageP get image => _sharedStateService.image;
  PColor _currentColor;
  PColor get currentColor {
    return _currentColor;
  }

  Product get product => _sharedStateService.product;

  final DatabaseService _databaseService = ProxyService.database;

  Future takePicture({BuildContext context}) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);

    await handleImage(image, context);
  }

  Future browsePictureFromGallery({BuildContext context}) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    await handleImage(image, context);
  }

  Future<File> compress(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 80,
      minWidth: 80,
      quality: 95,
      rotate: 0,
    );

    return result;
  }

  Future handleImage(File image, BuildContext context) async {
    if (image != null) {
      final store = StoreProvider.of<AppState>(context);

      final String targetPath = (await getTemporaryDirectory()).path +
          '/' +
          DateTime.now().toIso8601String() +
          '.jpg';

      final File compresedFile = await compress(image, targetPath);

      final String fileName = compresedFile.path.split('/').removeLast();
      final String storagePath =
          compresedFile.path.replaceAll('/' + fileName, '');

      // FIXME(richard): fix bellow code
      // ProductTableData product = await store.state.database.productDao
      //     .getItemById(productId: widget.productId);

      // store.state.database.productDao.updateProduct(product.copyWith(
      //     picture: compresedFile.path, isImageLocal: true, hasPicture: true));

      // ProductTableData productUpdated = await store.state.database.productDao
      //     .getItemById(productId: widget.productId);
      final Document productUpdated = _databaseService.getById(id: product.id);

      _sharedStateService.setProduct(
          product: Product.fromMap(productUpdated.map));

      store.dispatch(
        ImagePreview(
          image: ImageP(
            (ImagePBuilder img) => img
              ..path = compresedFile.path
              ..isLocal = true,
          ),
        ),
      );
      // FIXME(richard): fix bellow code
      // store.state.database.productImageDao.insertImageProduct(
      //   //ignore: missing_required_param
      //   ProductImageTableData(
      //     localPath: compresedFile.path,
      //     productId: widget.productId,
      //   ),
      // );

      final bool internetAvailable = await isInternetAvailable();
      if (internetAvailable) {
        upload(
            store: store,
            fileName: fileName,
            productId: product.id,
            storagePath: storagePath);
      }
    }
  }

  Future<bool> isInternetAvailable() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> upload(
      {String storagePath,
      String fileName,
      Store<AppState> store,
      String productId}) async {
    final FlutterUploader uploader = FlutterUploader();

    await uploader.enqueue(
        url: 'https://test.flipper.rw/api/upload',
        // ignore: always_specify_types
        files: [
          FileItem(
              filename: fileName, savedDir: storagePath, fieldname: 'image')
        ], // required: list of files that you want to upload
        method: UploadMethod.POST,
        // ignore: always_specify_types
        headers: {'Authorization': 'Bearer  ' + store.state.user.token},
        // ignore: always_specify_types
        data: {'product_id': productId},
        showNotification:
            true, // send local notification (android only) for upload status
        tag: 'Backup products images...'); // unique tag for upload task

    uploader.progress.listen((UploadTaskProgress progress) {
      //... code to handle progress
      print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      final UploadResponse uploadResponse =
          uploadResponseFromJson(result.response);
      // final ProductTableData product = await store.state.database.productDao
      //     .getItemById(productId: uploadResponse.productId);
      final DatabaseService _databaseService = ProxyService.database;
      final Document productDoc =
          _databaseService.getById(id: uploadResponse.productId);

      final Product product = Product.fromMap(productDoc.map);

      // TODO(richard): update url here
      // await store.state.database.productDao.updateProduct(
      //     pro.copyWith(picture: uploadResponse.url, isImageLocal: false));

      // List<ProductImageTableData> p = await store.state.database.productImageDao
      //     .getByid(productId: productId);
      // for (var i = 0; i < p.length; i++) {
      //   store.state.database.productImageDao.deleteImageProduct(p[i]);
      // }

      // ignore: always_specify_types
    }, onError: (ex, stacktrace) {
      print('error' + stacktrace.toString());
    });
  }

  void observeColors() {
    setBusy(true);

    final List<PColor> colors = [];
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.color};

    q.addChangeListener(( results) {
      for (Map map in results.allResults) {
        map.forEach((key, value) {
          if(!colors.contains(PColor.fromMap(value))){
            colors.add(PColor.fromMap(value));
          }
        });
        _sharedStateService.setColors(colors: colors);

        setBusy(false);
        notifyListeners();
      }
    });
  }

  void switchColor({PColor color, @required BuildContext context}) async {
    //reset all other color to not selected
    log.d(colors.length);
    setBusy(true);
    for (var y = 0; y < 8; y++) { //we know color lenght is 8, using colors.lenght was giving dups!
      //set all other color to active false then set one to active.
      final Document _color = _databaseService.getById(id: colors[y].id);

      _color.properties['isActive'] = false;
      _databaseService.update(document: _color);
    }
    final Document _colordoc = _databaseService.getById(id: color.id);

    _colordoc.properties['isActive'] = true;
    _databaseService.update(document: _colordoc);

    _sharedStateService.setCurrentColor(color: color, context: context);

    _currentColor = color;

    setBusy(false);

    notifyListeners();
  }
}