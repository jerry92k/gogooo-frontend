import 'package:flutter/material.dart';

class PopupAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color color;
  final double isElevation;

  PopupAppBar({this.title, this.color, this.isElevation});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // 뒤로가기 버튼 삭제
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: color == null ? Colors.white : color,
      elevation: isElevation == null ? 0.0 : isElevation,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          tooltip: 'close',
          onPressed: () {
            try {
              Navigator.pop(context); //close the popup
            } catch (e) {}
          },
        ),
      ],
      centerTitle: true,
      brightness: Brightness.light,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
