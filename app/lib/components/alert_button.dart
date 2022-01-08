import 'package:flutter/material.dart';

class AlertButton extends StatelessWidget {
  final String text;
  final Function onTab;
  final bool isCancel;

  const AlertButton({Key key, this.text, this.onTab, this.isCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isCancel ? FontWeight.w100 : FontWeight.w500,
            fontSize: 14.0,
            color: isCancel ? Colors.black : Colors.white,
          ),
        ),
      ),
      onTap: onTab,
    );
  }
}
