import 'package:app/constants/txt_style_constants.dart';
import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  IconData icon;
  String title;

  IconAndText({this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.black,
            size: 14.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            style: kFieldTitleTextStyle,
          )
        ],
      ),
    );
  }
}
