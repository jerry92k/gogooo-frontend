import 'package:flutter/material.dart';

class OrganizerMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.outlined_flag,
          color: Colors.black,
          size: 15.0,
        ),
        Text(
          '모임장',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
