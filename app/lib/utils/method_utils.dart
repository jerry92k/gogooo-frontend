import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

//TODO: snackbar 디자인
SnackBar getSnackBar(String text) {
  return SnackBar(
    backgroundColor: kSnackbarColor,
    duration: Duration(milliseconds: 1000),
    content: new Text(text),
  );
}

AlertDialog getAlertMessage(BuildContext context, String title, String body) {
  return AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
