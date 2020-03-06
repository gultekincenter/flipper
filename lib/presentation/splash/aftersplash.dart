import 'dart:io';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:query_params/query_params.dart';
import 'package:url_launcher/url_launcher.dart';

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //remove anykeyboard that might have initialized from some pages.
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.unfocus();
    // }
    return Scaffold(
      body: Wrap(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2 / 2,
            child: Container(
              color: HexColor("#955be9"),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                  ),
                  Container(
                    height: 60,
                    child: Image.asset("assets/graphics/logo.png"),
                  ),
                  Container(
                    height: 40,
                  ),
                  Text(
                    S.of(context).flipperPointofSale,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    S.of(context).interactandgrowyourbusiness,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 2 / 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 20,
                  ),
                  Container(
                    color: Colors.blue,
                    child: SizedBox(
                      width: 380,
                      height: 60,
                      child: FlatButton(
                        onPressed: () async {
                          URLQueryParams query = new URLQueryParams();
                          query.append('client_id', "49");
                          query.append('redirect_uri',
                              "https://test.flipper.rw/auth/callback");
                          query.append('response_type', "code");
                          query.append('scope', "");
                          query.append('state', "");

                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              var url =
                                  'https://test.yegobox.com/oauth/authorize?' +
                                      query.toString();
                              if (await canLaunch(url)) {
                                //await launch(url);
                                Router.navigator.pushNamed(Router.webView,
                                    arguments: AuthWebViewArguments(
                                        url: url, authType: 'register'));
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "There is a problem launching login url",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          } on SocketException catch (_) {
                            Fluttertoast.showToast(
                                msg: "you are not connected to internet",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        color: Colors.blue,
                        child: Text(
                          S.of(context).createAccount,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      width: 380,
                      height: 60,
                      child: StoreConnector<AppState, CommonViewModel>(
                        distinct: true,
                        converter: CommonViewModel.fromStore,
                        builder: (context, vm) {
                          return OutlineButton(
                            color: Colors.blue,
                            child: Text(
                              S.of(context).signIn,
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              URLQueryParams query = new URLQueryParams();
                              query.append('client_id', "49");
                              query.append('redirect_uri',
                                  "https://test.flipper.rw/auth/callback");
                              query.append('response_type', "code");
                              query.append('scope', "");
                              query.append('state', "");

                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  var url =
                                      'https://test.yegobox.com/oauth/authorize?' +
                                          query.toString();
                                  if (await canLaunch(url)) {
                                    //await launch(url);
                                    Router.navigator.pushNamed(Router.webView,
                                        arguments: AuthWebViewArguments(
                                            url: url, authType: 'login'));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "There is a problem launching login url",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }
                              } on SocketException catch (_) {
                                Fluttertoast.showToast(
                                    msg: "There is no internet",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                return;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
//todo: implement learn about flipper ASAP.
//                  Container(
//                    color: Colors.white,
//                    child: SizedBox(
//                      width: 380,
//                      height: 60,
//                      child: FlatButton(
//                        child: Text(
//                          S.of(context).learnaboutFlipper,
//                          style: TextStyle(color: Colors.black54, fontSize: 20),
//                        ),
//                        onPressed: () async {
//                          var url = 'https://yegobox.com';
//                          if (await canLaunch(url)) {
//                            await launch(url);
//                          } else {
//                            throw 'Could not launch $url';
//                          }
//                        },
//                      ),
//                    ),
//                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
