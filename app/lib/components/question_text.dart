import 'package:app/constants/txt_style_constants.dart';
import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  String text;
  Function onTab;

  double fontSize = 14.0;

  QuestionText({this.text, this.onTab});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double textLen = text.length * fontSize;
    double indent = (deviceWidth - textLen) / 2;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onTab,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: kBasicFontFamily,
                fontWeight: FontWeight.w100,
                fontSize: fontSize,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Color(0xff666666),
          height: 10.0,
          indent: indent,
          endIndent: indent,
        ),
      ],
    );
  }
}
