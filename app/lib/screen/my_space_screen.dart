import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/meeting_item.dart';
import 'package:app/components/my_record_item.dart';
import 'package:app/components/time_line_meeting_item.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/model/meeting_data.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/meeting_screen.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';

class MySpaceScreen extends StatefulWidget {
  static String id = '/my_space_screen';

  @override
  _MySpaceScreenState createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends State<MySpaceScreen>
    with SingleTickerProviderStateMixin {
  List<MeetingData> meetingDataList = [];

  NodeConnector _nodeConnector;

  ScrollController _scrollController;

  MyUser myUser;

  bool isInit;

  // var _futureFetch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nodeConnector = NodeConnector();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    isInit = true;
    myUser = MyUser();
    //  _futureFetch = _fetchMeets;
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('scroll bottom');

      print('meeting data : ${meetingDataList.length}');

      int lastIdx = meetingDataList.length + 1;

      fetchMeetMoreDatas(false, lastIdx);
      //  });
    } else if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('scroll top');

      int lastIdx = 1;
      fetchMeetMoreDatas(true, lastIdx);
    }
  }

  Future fetchMeetMoreDatas(bool isRefresh, int lastIdx) async {
    String url = '$fetchDataUrl$lastIdx';

    print('here url');
    var data = await _nodeConnector.getWithNonAuth(url);
    var resultData = data[0]["results"];

    if (resultData == null) {
      print('here null');
      return null;
    }

    print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    if (isRefresh) {
      meetingDataList.clear();
      setState(() {
        meetingDataList = parsed
            .map<MeetingData>((json) => MeetingData.fromJson(json))
            .toList();
      });
    } else {
      setState(() {
        meetingDataList.addAll(parsed
            .map<MeetingData>((json) => MeetingData.fromJson(json))
            .toList());
      });
    }
  }

  int tabIndex = 0;
  bool screenInit = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      return Scaffold(
        body: DefaultTabController(
          length: 3,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 300.0,
                floating: true,
                pinned: true,
                snap: true,
                //forceElevated: innerBoxIsScrolled,
                // 뒤로가기 버튼
                leading: BackButtonLeadingAppbar(
                  color: Colors.white,
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      tooltip: 'setting',
                      onPressed: () {}),
                ],
                //flexibleSpace: _MySpace(myUser: myUser),
                flexibleSpace: _MySpace(),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      //  controller: _tabController,
                      //labelColor: Colors.black,
                      onTap: (int index) async {
                        print('here event');
                        //     await fetchMeets(index);
                        print('changed Tab Index: $index');

                        var data = await fetchOnTap(index);
                        print('on tap');
                        print(data);
                        setState(() {
                          tabIndex = index;
                          meetingDataList = data
                              .map<MeetingData>(
                                  (json) => MeetingData.fromJson(json))
                              .toList();
                          // isInit = true;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Container(
                            child: Text(
                              '예정모임',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                            child: Container(
                          child: Text(
                            '지난모임',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                        )),
                        Tab(
                          child: Container(
                            child: Text(
                              '관심모임',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: FutureBuilder(
                    future: fetchMeets(tabIndex),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('here get data');
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
                            .map<MeetingData>(
                                (json) => MeetingData.fromJson(json))
                            .toList();
                      }
                      isInit = false;
                      return Container(
                        //   child: Container(
                        color: Color(0xfff5f5f5),
                        child: TabBarView(
                          //  controller: _tabController,
                          children: [
                            new Builder(builder: (BuildContext context) {
                              return tabIndex == 0
                                  ? meetingDataList.length > 0
                                      ? getTabList(0)
                                      : getEmptyMeetContainer(0)
                                  : Container();
                            }),
                            new Builder(builder: (BuildContext context) {
                              return tabIndex == 1
                                  ? meetingDataList.length > 0
                                      ? getTabList(1)
                                      : getEmptyMeetContainer(1)
                                  : Container();
                            }),
                            new Builder(builder: (BuildContext context) {
                              return tabIndex == 2
                                  ? meetingDataList.length > 0
                                      ? getTabList(2)
                                      : getEmptyMeetContainer(2)
                                  : Container();
                            }),
                          ],
                        ),
                        //   ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget getEmptyMeetContainer(int meetTpcd) {
    return Container(
      alignment: Alignment.center,
      child: Text(meetTpcd == 0
          ? '예정된 모임이 없어요.'
          : meetTpcd == 1
              ? '지난 모임이 없어요.'
              : '관심 모임이 없어요.'),
    );
  }

  Widget getTabList(int meetTpcd) {
    return new ListView.builder(
      itemCount: meetingDataList == null ? 0 : meetingDataList.length,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return meetTpcd == 0
            ? new TimeLineMeetingItem(
                meetingData: meetingDataList[index],
                isLast: index == (meetingDataList.length - 1) ? true : false)
            : new MeetingItem(
                meetingData: meetingDataList[index],
              );
      },
    );
  }

  String fetchDataUrl = '';
  //nt lastIdx = 1;

  Future fetchMeets(int Meettpcd) async {
    if (!isInit) {
      return meetingDataList;
    }
    print('init method inside, Meettpcd 123213: $Meettpcd');

    meetingDataList.clear();
    String lastPath = Meettpcd == 0
        ? 'pre'
        : Meettpcd == 1
            ? 'post'
            : 'like';

    int userId = myUser.id;

    int lastIdx = 1;
    fetchDataUrl = getkMySpaceMeets(userId, lastPath);

    String url = '$fetchDataUrl$lastIdx';

    var data = await _nodeConnector.getWithNonAuth(url);
    var resultData = data[0]["results"];

    //print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    print('here inside2 ?');
    print(parsed);

    //  print(meetingDataList.length);
    return parsed;
  }

  Future fetchOnTap(int Meettpcd) async {
    print('init method inside, Meettpcd dsadas: $Meettpcd');

    meetingDataList.clear();
    String lastPath = Meettpcd == 0
        ? 'pre'
        : Meettpcd == 1
            ? 'post'
            : 'like';

    int userId = myUser.id;

    int lastIdx = 1;
    fetchDataUrl = getkMySpaceMeets(userId, lastPath);

    String url = '$fetchDataUrl$lastIdx';

    var data = await _nodeConnector.getWithNonAuth(url);
    var resultData = data[0]["results"];

    //print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    print('here inside2 ?');
    print(parsed);

    //  print(meetingDataList.length);
    return parsed;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _MySpace extends StatefulWidget {
  _MySpace();

  @override
  __MySpaceState createState() => __MySpaceState();
}

class __MySpaceState extends State<_MySpace> {
  final double layMargin = 15.0;

  bool isInit = true;

  //var _futureFetch;

  @override
  void initState() {
    // TODO: implement initState
    // _futureFetch = _fetchUserScore;
    super.initState();
  }

  String preCount = '';
  String postCount = '';
  String likeCount = '';
  String ownCount = '';

  @override
  Widget build(BuildContext context) {
    isInit = true;
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      return LayoutBuilder(builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0) as double;
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('./images/background-meeting-001.png'),
                    fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                // 캐릭터, [닉네임, 행성아이디, 취미]
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 90.0,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                  image: new AssetImage(myUserData
                                          .myUser.profileImgPath ??
                                      './images/profile-icons/cha-earth_1.png'),
                                  fit: BoxFit.fitWidth),
                            )),
                        Container(
                          margin: EdgeInsets.only(left: layMargin),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    myUserData.myUser.name,
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'BA12354',
                                    //     myUserData.myUser.starCode,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // : 100 은 아이콘
                                  width: MediaQuery.of(context).size.width -
                                      100 -
                                      layMargin * 2,
                                  child: Text(
                                    myUserData.myUser.hashtags,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(right: layMargin),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${myUserData.myUser.gravityVal}N/100',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: layMargin),
                    child: Row(
                      children: <Widget>[
                        // 매너온도
                        Text(
                          '나의 그래비티',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Icon(
                          Icons.help_outline,
                          size: 15.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: layMargin),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.black,
                              value: 0.6,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff1ed69e)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //나의 매너온도, 매너온도[percent indicator]
                Container(
                  height: 130.0,
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.12,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: layMargin,
                              right: layMargin,
                              bottom: layMargin),
                          color: Colors.white,
                        ),
                      ),
                      FutureBuilder(
                          future: _fetchUserScore(myUserData.myUser.id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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

                              var recordData = snapshot.data;
                              if (recordData == null) {
                                return Text('데이터를 불러오는데 실패했습니다.');
                              }
                              print('here get recordData');
                              print(recordData);
                              //print('pre : ${recordData("NUM_OF_PRE")');

                              preCount = recordData['NUM_OF_PRE'].toString();
                              postCount = recordData['NUM_OF_POST'].toString();
                              likeCount = recordData['NUM_OF_LIKE'].toString();
                              ownCount = recordData['NUM_OF_OWN'].toString();
/*
                              String preCount =
                                  recordData['NUM_OF_PRE'].toString();
                              String postCount =
                                  recordData['NUM_OF_POST'].toString();
                              String likeCount =
                                  recordData['NUM_OF_LIKE'].toString();
                              String ownCount =
                                  recordData['NUM_OF_OWN'].toString();
 */
                            }
                            isInit = false;
                            print(isInit);
                            print('rebuildted user data');
                            return Container(
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  //TODO : 수치는 서버에서 읽어와서 셋팅
                                  MyRecordItem(
                                      recordNumber: preCount,
                                      recordTitle: kPostMeet),
                                  MyRecordItem(
                                      recordNumber: postCount,
                                      recordTitle: kPreMeet),
                                  MyRecordItem(
                                      recordNumber: likeCount,
                                      recordTitle: kInstMeet),
                                  MyRecordItem(
                                      recordNumber: ownCount,
                                      recordTitle: kMadeMeet),
                                ],
                              ),
                              // }),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  Future _fetchUserScore(int userId) async {
    if (!isInit) {
      return;
    }
    NodeConnector _nodeConnector = NodeConnector();

    var data = await _nodeConnector.getWithNonAuth(getkUserRecords(userId));
    var resultData = data[0]["results"];

    print('here score fetch');

    return resultData;
  }
}
