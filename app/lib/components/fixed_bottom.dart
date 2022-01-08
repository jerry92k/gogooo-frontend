import 'package:flutter/material.dart';

class FixedBottom extends StatelessWidget {
  List<Widget> buttons;
  FixedBottom(this.buttons);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: kPostButtonMargin,
      padding: EdgeInsets.all(0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: buttons,
      ),
    );
  }
}
