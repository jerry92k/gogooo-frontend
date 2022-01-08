import 'package:app/popup_layout.dart';
import 'package:app/screen/interest_icon_select_screen.dart';
import 'package:flutter/material.dart';

class UploadPhotoIcon extends StatelessWidget {
  final Function onPressed;

  Image image;
  UploadPhotoIcon({
    this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0,
      height: 35.0,
      child: RawMaterialButton(
        onPressed: onPressed,
        //     () {
        //   Navigator.push(
        //     context,
        //     PopupLayout(
        //       child: InterestIconSelectScreen(),
        //     ),
        //   );
        // },
        //interestIconId
        child: image ??
            new Icon(
              Icons.image,
              color: Color(0xff4545f1),
              size: 18.0,
            ),
        shape: new CircleBorder(
            side: BorderSide(
          color: Color(0xff4545f1),
          width: 0.3,
        )),
        elevation: 2.0,
        padding: const EdgeInsets.all(2.0),
      ),
    );
  }
}
