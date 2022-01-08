import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();

  String hint;
  List<String> items;

  DropDown({
    this.hint,
    this.items,
  });
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Color(0xffb7b7b7),
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.only(left: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            items: widget.items.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {});
            },
            hint: Container(
                child: Row(
              children: <Widget>[
                Text(
                  widget.hint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: Colors.black,
                  size: 12,
                ),
              ],
            ))),
      ),
    );
  }
}
