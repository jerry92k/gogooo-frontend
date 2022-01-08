import 'package:flutter/material.dart';

class MyRecordItem extends StatefulWidget {
  String recordNumber;
  String recordTitle;

  MyRecordItem({this.recordNumber, this.recordTitle});

  @override
  _MyRecordItemState createState() => _MyRecordItemState();
}

class _MyRecordItemState extends State<MyRecordItem> {
  @override
  Container build(BuildContext context) {
    return Container(
      height: 70.0,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          widget.recordNumber,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        Text(
          widget.recordTitle,
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w100),
        ),
      ]),
    );
  }
}
