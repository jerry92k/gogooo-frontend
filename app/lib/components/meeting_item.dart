import 'package:app/constants/txt_style_constants.dart';
import 'package:app/meeting_components/hashtags.dart';
import 'package:app/meeting_components/interest_title.dart';
import 'package:app/meeting_components/organizer_mark.dart';
import 'package:app/model/meeting_data.dart';
import 'package:app/screen/meeting_detail_screen.dart';
import 'package:flutter/material.dart';

class MeetingItem extends StatefulWidget {
  MeetingData meetingData;
  MeetingItem({this.meetingData});

  @override
  _MeetingItemState createState() => _MeetingItemState();
}

class _MeetingItemState extends State<MeetingItem> {
  final double favoriteSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        height: 130.0,
        //padding: EdgeInsets.only(bottom: 10.0),
        //margin: EdgeInsets.only(bottom:10.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 좌측 아이콘 영역
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xffe8eaf6),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          right: 5,
                          bottom: 5,
                          child: new Image.asset(
                            widget.meetingData.image,
                            width: 120.0,
                            height: 120.0,
                          ),
                        ),
                        // 좋아요 버튼
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: new MaterialButton(
                            onPressed: () {
                              setState(() {
                                widget.meetingData.likeYn =
                                    widget.meetingData.likeYn == 'Y'
                                        ? 'N'
                                        : 'Y';
                              });
                            },
                            height: 24,
                            shape: new CircleBorder(),
                            elevation: 0.0,
                            color: Colors.black12,
                            padding: EdgeInsets.all(2),
                            child: widget.meetingData.likeYn == 'Y'
                                ? Icon(
                                    Icons.favorite,
                                    color: Color(0xffff3939),
                                    size: favoriteSize,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                    size: favoriteSize,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 우측 모임정보 영역
                  Expanded(
                    child: Container(
                      height: 110.0,
                      padding: EdgeInsets.only(left: 12, top: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // 카테고리
                                InterestTitle(
                                    insTitle: widget.meetingData.interestNm),
                                // 해시태그
                                HashTags(
                                  hashtags: widget.meetingData.hashTags,
                                ),
                              ],
                            ),
                          ),
                          // 모임 타이틀
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  height: 50.0,
                                  child: Text(
                                    widget.meetingData.meetingTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: kMeetTitleStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            //padding: EdgeInsets.only(right: 4),
                            width: MediaQuery.of(context).size.width - 140,
                            child: Row(
                              children: <Widget>[
                                // 모임장소
                                new Text(
                                  widget.meetingData.locationTitle,
                                  style: kMeetLocaStyle,
                                ),
                                Container(
                                  height: 10.0,
                                  child: VerticalDivider(
                                    // indent: 10.0,
                                    // width: 10.0,
                                    // thickness: 10.0,
                                    color: Colors.grey,
                                    //color: Color(0xffeeeeee),
                                  ),
                                ),
                                // 모임정원
                                Text(
                                  '${widget.meetingData.numOfPeople} / ${widget.meetingData.maxUserNum}명',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xff666666)),
                                ),
                              ],
                            ),
                          ),
                          // 모임일시, 모임장여부
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.meetingData.meetingDate,
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff666666)),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 15.0),
                                child: widget.meetingData.organizerYn == 'Y'
                                    ? OrganizerMark()
                                    : Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // 가로 구분선 영역
            Divider(
              //width: MediaQuery.of(context).size.width,
              thickness: 1.0,
              color: Color(0xffeeeeee),
            ),
            // Container(
            //   height: 1,
            //   color: Color(0xffeeeeee),
            // ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MeetingDetailScreen(meetingData: widget.meetingData)),
        );
      },
    );
  }
}
