import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  String text;
  Function onPressed;

  PostButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: double.infinity,
      child: MaterialButton(
        onPressed: onPressed,
        height: kBottomButtonSize,
        color: Color(0xff4545f1),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
