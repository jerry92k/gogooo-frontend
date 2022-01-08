import 'package:flutter/material.dart';

class StarProfileRow extends StatelessWidget {
  String image;
  String name;
  String comment;

  StarProfileRow({this.image, this.name, this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.asset(image),
        SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              comment,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        )
      ],
    );
  }
}
