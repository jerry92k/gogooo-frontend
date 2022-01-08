import 'package:app/constants/txt_style_constants.dart';
import 'package:app/constants/constants.dart';

import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/model/notice_data.dart';
import 'package:provider/provider.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatefulWidget {
  static String id = '/notice_detail_screen';
  final NoticeData noticeData;

  NoticeDetailScreen({Key key, @required this.noticeData}) : super(key: key);

  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  MyUser myUser;
  bool isInit = true;
  List<NoticeData> noticeDataList;
  NodeConnector _nodeConnector;

  @override
  void initState() {
    super.initState();
    _nodeConnector = NodeConnector();
  }

  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          brightness: Brightness.light,
          elevation: 0.0,
          leading: BackButtonLeadingAppbar(),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _fetchNoticeDetailList(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (isInit) {
                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
                var data = snapshot.data;

                noticeDataList = data
                    .map<NoticeData>((json) => NoticeData.fromJson(json))
                    .toList();
              }
              isInit = false;
              return ListView.builder(
                itemCount: noticeDataList == null ? 0 : noticeDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: kBodyMargin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 공지사항 제목
                        Container(
                          child: new Text(
                            noticeDataList[0].title,
                            style: kMeetTitleStyle,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        // 게시일시
                        Container(
                          child: new Row(
                            children: <Widget>[
                              Text(
                                noticeDataList[0].date +
                                    ' ' +
                                    noticeDataList[0].ap +
                                    ' ' +
                                    noticeDataList[0].time,
                                style: kLightTextStyle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        // 공지사항 내용
                        new Text(noticeDataList[0].contents),
                      ],
                    ),
                  );
                },
              );
            }),
      );
    });
  }

  Future _fetchNoticeDetailList(BuildContext contex) async {
    if (!isInit) {
      return null;
    }

    if (myUser == null) {
      // 유저 정보 없으면 오류.
      return null;
    }

    var data = await _nodeConnector
        .getWithNonAuth(kGetNoticeDetailList(widget.noticeData.id));

    var resultData = data[0]["results"];

    if (resultData == null) {
      print('here null');
      return null;
    }

    print('resultData');
    print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    return parsed;
  }
}
