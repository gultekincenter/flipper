import 'package:flipper/presentation/widgets/button.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  @Deprecated("_action will be removed soon")
  final Widget _additionalText;
  final bool _showActionButton;

  final String _title;
  final String _actionButtonName;

  final IconData _icon;
  final double _headerMultiplier;
  @Deprecated("_bottomSpacer will be removed soon")
  final double _bottomSpacer;
  final Function _onPressedCallback;
  final bool _disableButton;
  const CommonAppBar({
    Widget action,
    bool showActionButton,
    @required String title,
    IconData icon,
    double multi,
    double bottomSpacer,
    bool disableButton,
    Function onPressedCallback,
    String actionButtonName,
    Key key,
  })  : _additionalText = action,
        _showActionButton = showActionButton,
        _title = title,
        _icon = icon,
        _headerMultiplier = multi,
        _bottomSpacer = bottomSpacer,
        _disableButton = disableButton,
        _onPressedCallback = onPressedCallback,
        _actionButtonName = actionButtonName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          height: _bottomSpacer,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.5),
                leading: GestureDetector(
                  onTap: () {
                    //close the page.
                    Router.navigator.pop();
                  },
                  child: Icon(
                    _icon ?? Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                title: _title == null
                    ? Text("")
                    : Text(
                        _title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.appBarTitleTextStyle,
                      ),
                trailing: _showActionButton == null || !_showActionButton
                    ? Text("")
                    : button(
                        disableButton: _disableButton,
                        onPressedCallback: _onPressedCallback,
                        buttonName: _actionButtonName ?? "",
                      ),
                dense: true,
              ),
              Container(
                child: _additionalText,
              ),
              Expanded(
                child: Divider(
                  color: Colors
                      .black, //todo: tweak this divider so it can be visible
                ),
              )
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.appBarSize *
      (_headerMultiplier == null ? 0.8 : _headerMultiplier));
}
