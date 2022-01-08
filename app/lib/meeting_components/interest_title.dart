import 'package:flutter/material.dart';

class InterestTitle extends StatelessWidget {
  String insTitle;
  InterestTitle({this.insTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
      height: 18.0,
      child: Text(
        insTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xff1ed69e),
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
    );
  }
}
