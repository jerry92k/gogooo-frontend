import 'package:flutter/material.dart';
import 'package:app/model/notice_data.dart';
import 'package:app/screen/notice_screen.dart';
import 'package:app/screen/notice_detail_screen.dart';

class NoticeTile extends StatefulWidget {
  NoticeData noticeData;
  NoticeTile({this.noticeData});

  @override
  _SettingTileState createState() => _SettingTileState();
}

class _SettingTileState extends State<NoticeTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
//      leading: Image.asset(widget.noticeData.date),
      title: Text(widget.noticeData.title),
      subtitle: Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(widget.noticeData.date + ' '),
            Text(widget.noticeData.ap + ' '),
            Text(widget.noticeData.time),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NoticeDetailScreen(noticeData: widget.noticeData)),
        );
      },
    );
  }
}
