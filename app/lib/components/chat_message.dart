import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/chat.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Chat chat;
  bool isMine;
  bool hasHead;
  bool hasTail;
  AnimationController animationController;

  ChatMessage(
      {this.chat,
      this.isMine,
      this.hasHead,
      this.hasTail,
      this.animationController});

  @override
  Widget build(BuildContext context) {
//    return Container(
//      margin: const EdgeInsets.symmetric(vertical: 10.0),
//      // child: isRev ? getRcvChat() : getSentChat(),
//      child: chat.senderId == 0
//          ? getSystemChat()
//          : isMine ? getSentChat() : getRcvChat(),
//    );
    return SizeTransition(
      // 사용할 애니메이션 효과 설정
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      // 리스트뷰에 추가될 컨테이너 위젯
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        // child: isRev ? getRcvChat() : getSentChat(),
        child: chat.senderId == 0
            ? getSystemChat()
            : isMine ? getSentChat() : getRcvChat(),
      ),
    );
  }

  Widget getRcvChat() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 7.0),
          padding: EdgeInsets.only(bottom: 16.0),
          //TODO : profileIconID로 프로필 사진 넣기
          child: hasHead
              ? CircleAvatar(
                  backgroundImage: AssetImage(chat.profileImgPath),
                )
              : Container(
                  child: SizedBox(
                    width: 40.0,
                    //height: 40.0,
                  ),
                ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            hasHead
                ? Text(
                    chat.senderName,
                  )
                : Container(),
            Bubble(
              margin: BubbleEdges.only(top: 10),
              elevation: 3.0,
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftTop,
              color: Color(0xfff5f5f5),
              child: Text(
                chat.text,
                style: kRcvChatTextStyle,
              ),
            ),
          ],
        ),
        hasTail ? Text(chat.inputTime) : Text(''),
      ],
    );
  }

  Widget getSentChat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        hasTail ? Text(chat.inputTime) : Text(''),
        Bubble(
          margin: BubbleEdges.only(top: 5.0),
          elevation: 3.0,
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          color: Color(0xff4545f1),
          child: Text(
            chat.text,
            style: kSentChatTextStyle,
          ),
        ),
      ],
    );
  }

  Widget getSystemChat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 5.0),
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          color: Color(0xffb7b7b7),
          child: Text(
            chat.text,
            style: kSystemChatTextStyle,
          ),
        ),
      ],
    );
  }
}
