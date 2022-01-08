import 'package:app/components/dropdown.dart';
import 'package:app/components/meeting_item.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/model/meeting_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/interest_category_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeetingScreen extends StatefulWidget {
  static String id = '/meeting_screen';

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  List data = [];
  int userID = 0;
  List interestCategoryData = [];
  //List<MeetingItem> meetingItems;
  List<MeetingData> meetingDataList;

  final double favoriteSize = 15.0;
  final double notificationSize = 30.0;
  int counter = 999;
  NodeConnector _nodeConnector;

  ScrollController _controller;

  MyUser myUser;

  int lastIdx = 1;
  //bool isInit = true;

  int maxMeetId = 0;

  @override
  void initState() {
    super.initState();

    _nodeConnector = NodeConnector();

    //리스트뷰 컨트롤
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    // _controller.animateTo(
    //   _controller.position.maxScrollExtent,
    //   duration: Duration(seconds: 1),
    // );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print(meetingDataList.length);
      lastIdx = meetingDataList.length + 1;

      fetchMeetMoreDatas(false);
      //  });
    } else if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      lastIdx = 1;

      fetchMeetMoreDatas(true);
      //setState(() {
      // message = "reach the top";
      // });
    }
  }

  Future fetchMeetMoreDatas(bool isRefresh) async {
    if (isRefresh) {
      var data = await _nodeConnector.getWithNonAuth(kMaxMeetId);
      var resultData = data[0]["results"];
      if (resultData == null) {
        print('max meet id is null');
        return null;
      }
      //단건 리턴
      maxMeetId = resultData['MAX_MEET_ID'];
    }
    var data = await _nodeConnector
        .getWithNonAuth(getkMeetList(myUser.id, maxMeetId, lastIdx));
    var resultData = data[0]["results"];

    if (resultData == null) {
      print('here null');
      return null;
    }
    print('resultData');
    print(resultData);

    var parsed = resultData.cast<Map<String, dynamic>>();

    if (isRefresh) {
      setState(() {
        print('new list');
        meetingDataList.clear();
        meetingDataList = parsed
            .map<MeetingData>((json) => MeetingData.fromJson(json))
            .toList();
      });
    } else {
      setState(() {
        print('add list');
        meetingDataList.addAll(parsed
            .map<MeetingData>((json) => MeetingData.fromJson(json))
            .toList());
      });
    }
  }

  bool isInit = true;
  Future fetchMeetDatas() async {
    if (!isInit) {
      // return null;
    }

    if (myUser == null) {
      // 유저 정보 없으면 오류.
      return null;
    }

    var data = await _nodeConnector.getWithNonAuth(kMaxMeetId);
    var resultData = data[0]["results"];
    if (resultData == null) {
      print('max meet id is null');
      return null;
    }
    //단건 리턴
    maxMeetId = resultData['MAX_MEET_ID'];

    data = await _nodeConnector
        .getWithNonAuth(getkMeetList(myUser.id, maxMeetId, lastIdx));
    resultData = data[0]["results"];

    if (resultData == null) {
      print('here null');
      return null;
    }

    print('resultData');
    print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            // back bottn 삭제
            title: Text(
              '모임',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  new IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      tooltip: 'Notification',
                      onPressed: () {
                        setState(() {
                          counter = 0;
                        });
                      }),
                  counter > 0
                      ? new Positioned(
                          right: 12,
                          top: 11,
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SizedBox(
                              width: 5,
                              height: 5,
                            ),
                          ))
                      : new Container()
                ],
              ),
            ]),
        body: FutureBuilder(
            future: fetchMeetDatas(),
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

                meetingDataList = data
                    .map<MeetingData>((json) => MeetingData.fromJson(json))
                    .toList();
                isInit = false;
              }

              return ListView.builder(
                controller: _controller,
                itemCount: meetingDataList == null ? 0 : meetingDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new MeetingItem(
                    meetingData: meetingDataList[index],
                  );
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          // 모임 만들기 화면
          onPressed: () async {
            Navigator.pushNamed(context, InterestCategorySelectScreen.id);
          },
          backgroundColor: Color(0xff4545f1),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Container buildDropDownMenu() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DropDown(
            hint: '카테고리',
            items: ['사교', '맛집', '공연전시', '커피'],
          ),
          DropDown(
            hint: '요일',
            items: ['월', '화', '수', '목', '금', '토', '일'],
          ),
          DropDown(
            hint: '모임상태',
            items: ['모집중', '모집완료'],
          ),
          DropDown(
            hint: '인원수',
            items: ['2명', '3명', '4명', '상관없음'],
          )
        ],
      ),
    );
  }

  Future _fetchInterestCategoryItems() async {
    var data = await _nodeConnector.getWithNonAuth(kGetInterestCategoryList);
    var interestCategoryData = data[0]["results"];
    // 토큰 만료 체크 후 필요시 리프레시
    //await _nodeConnector.refreshIfNeed();

    return interestCategoryData;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
