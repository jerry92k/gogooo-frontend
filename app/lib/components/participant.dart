import 'package:flutter/material.dart';

class Participant extends StatelessWidget {
  final String profileImageName;
  final String participantName;
  final int gravityLevel;
  final bool isMeetingOrganizer;
  final bool isBlackList;
  final bool isLiked;

  Participant({
    this.profileImageName,
    this.participantName,
    this.gravityLevel,
    this.isMeetingOrganizer,
    this.isBlackList,
    this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xfff5f5f5),
            width: 2.0,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(this.profileImageName),
            ),
          ),
        ),
        title: Text(
          this.participantName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('그래비티 ${this.gravityLevel}N',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w100,
              color: Color(0xff666666),
            )),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            this.isMeetingOrganizer
                ? Text(
                    '모임장',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4545f1),
                    ),
                  )
                : Text(''),
            this.isLiked
                ? Icon(
                    Icons.favorite,
                    color: Color(0xffff3939),
                  )
                : Text(''),
            this.isBlackList
                ? Icon(
//                    Icons.do_not_disturb_on,
                    Icons.mood_bad,
                    color: Color(0xff3a3a3a),
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
