import 'package:flutter/material.dart';

class HashTags extends StatelessWidget {
  String hashtags = '';

  HashTags({this.hashtags});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        hashtags,
        style: TextStyle(fontSize: 10, color: Color(0xff666666)),
      ),
    );
  }
}
