
import 'package:flipper/home/keypad/key_pad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Poswidget extends StatelessWidget {
  const Poswidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var moneyFormat =
        new MoneyMaskedTextController(leftSymbol: '\$', decimalSeparator: ".");
    moneyFormat.updateValue(0);
    return KeyPadWidget();
  }
}