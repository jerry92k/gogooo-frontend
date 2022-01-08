import 'package:app/arguments/ChatArgument.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/meeting_components/hashtags.dart';
import 'package:app/meeting_components/interest_title.dart';
import 'package:app/meeting_components/organizer_mark.dart';
import 'package:app/model/meeting_data.dart';
import 'package:app/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class TimeLineMeetingItem extends StatelessWidget {
  MeetingData meetingData;
  String todayDate; // xxxx.xx.xx
  bool isLast;

  Function onPressFunc;
  TimeLineMeetingItem(
      {this.meetingData, this.todayDate, this.isLast, this.onPressFunc});

  double layMargin = 15.0;

  @override
  Widget build(BuildContext context) {
    String dateFromData = meetingData.meetingDate.substring(0, 10);
    return Container(
        margin: EdgeInsets.only(right: layMargin),
        child: Column(
          children: <Widget>[
            Container(
              height: 35.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                          //radius: 20.0,
                          backgroundColor: Color(0xffe8eaf6),
                          child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: Image.asset(meetingData.image))),
                      Text(
                        todayDate == dateFromData ? '오늘' : dateFromData,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ), // 날짜
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        meetingData.meetingDate
                            .substring(11, meetingData.meetingDate.length),
                        style: TextStyle(color: Color(0xff666666)),
                      ), // 시간
                    ],
                  ),
                  meetingData.organizerYn == 'Y'
                      ? OrganizerMark()
                      : Container(),
                ],
              ),
            ),
            Container(
              height: 190.0,
              //padding: EdgeInsets.only(bottom: layMargin),
              margin: EdgeInsets.only(left: layMargin),
              child: Row(
                children: <Widget>[
                  isLast == true
                      ? Container()
                      : Container(
                          child: VerticalDivider(
                            color: Color(0xffb7b7b7),
                            //width: 10.0,
                            //thickness: 10.0,
                          ),
                        ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Card(
                      //padding: EdgeInsets.all(layMargin),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: layMargin, top: layMargin),
                              child: Row(
                                children: <Widget>[
                                  InterestTitle(
                                      insTitle: meetingData.interestNm),
                                  HashTags(hashtags: meetingData.hashTags),
                                ],
                              ),
                            ), // 카테로기, 해쉬태그
                            Container(
                              height: 40.0,
                              margin: EdgeInsets.only(
                                  left: layMargin, right: layMargin),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                meetingData.meetingTitle,
                                //textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: kMeetTitleStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: layMargin, right: layMargin),
                              alignment: Alignment.centerLeft,
                              child: Text(meetingData.locationTitle,
                                  style: kMeetLocaStyle),
                            ),
                            Divider(),
                            Container(
                              height: 40.0,
                              margin: EdgeInsets.only(
                                  right: layMargin, bottom: layMargin),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text(meetingData.organizerYn == 'Y'
                                        ? '수정하기'
                                        : '참여취소'),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xffb7b7b7),
                                            width: 2)),
                                    onPressed: onPressFunc,
                                    // 모임장이면 수정화면, 모임장이 아니면 server에 취소요청 보내고 list에서 삭제
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  RaisedButton(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.chat,
                                            size: 20.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text('채팅하기'),
                                        ],
                                      ),
                                    ),
                                    textColor: Colors.white,
                                    color: Color(0xff4545f1),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, ChatScreen.id,
                                          arguments: ChatArgument(
                                              meetingData.meetingId, []));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
