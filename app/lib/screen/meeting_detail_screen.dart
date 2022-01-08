import 'package:app/components/fixed_bottom.dart';
import 'package:app/arguments/ChatArgument.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/alert_button.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/location_data.dart';
import 'package:app/components/participant.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/meeting_data.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/model/user.dart';
import 'package:app/network/naver_api_connector.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeetingDetailScreen extends StatefulWidget {
  static String id = '/meeting_detail_screen';

  final MeetingData meetingData;

  MeetingDetailScreen({Key key, @required this.meetingData}) : super(key: key);

  @override
  _MeetingDetailScreenState createState() => _MeetingDetailScreenState();
}

//TODO: 모임 참가하기 눌렀을때 소켓에 연결된 사용자들에게 알림주기
class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  String response = '';
  //장소 지도맵
  Image locImage;
  NaverAPIConnector naverAPIConnector = NaverAPIConnector();
  NodeConnector _nodeConnector;
  List<User> users = [];
  var _isJoined = false;

  List<User> initUsersIn(var data) {
    var parsed = data.cast<Map<String, dynamic>>();
    var usersData = parsed.map<User>((json) => User.fromJson(json)).toList();

    return usersData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nodeConnector = NodeConnector();

    /*TODO: widget.meetingItem.isLiked 가 null일 경우 오류나서 처리. 어디서 null 처리 해줘야할지 확인필요
    if (widget.meetingData.isLiked == null) {
      widget.meetingData.isLiked = false;
    }*/

    if (widget.meetingData.joinYn == 'Y') {
      _isJoined = true;
    } else {
      _isJoined = false;
    }
    //   getLocationIMap();
  } // 역전할머니

  Future getLocationIMap() async {
    // Image tempImg;
    if (widget.meetingData.longitude != '') {
      locImage = await naverAPIConnector.getLocationIMap(
          widget.meetingData.longitude,
          widget.meetingData.latitude,
          kNaverMapClientIdKeyword,
          kNaverMapClientSecretKeyword);
    }
    return locImage;
    //locImage = await _getMapImage(locData.mapX, locData.mapY);

    // setState(() {
    //   locImage = tempImg;
    // });
  }

  MyUser myUser;

  Future _fetchUsers(context) async {
    if (myUser == null) {
      //토큰정보가 없어서 못불러오는거니 로그인부터 하는게 맞음
      return null;
    }

    int userId = myUser.id;

    // TODO: getkMeetInfo(2)=> meetingId 변수로 변경
    var data = await _nodeConnector.getWithNonAuth(
        getkPartiesInMeet(userId, widget.meetingData.meetingId));
    var usersList = data[0]["results"];
    print(usersList);

    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          // headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              // 뒤로가기 버튼
              leading: BackButtonLeadingAppbar(
                color: Colors.white,
              ),
              actions: <Widget>[
                IconButton(
                  icon: widget.meetingData.likeYn == 'Y'
                      //  icon: widget.meetingItem.isLiked!=null && widget.meetingItem.isLiked // widget.meetingItem.isLiked 가 null일 경우 오류나서 처리. 어디서 null 처리 해줘야할지 확인필
                      ? Icon(
                          Icons.favorite,
                          color: Color(0xffff3939),
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    setState(() {
                      widget.meetingData.likeYn =
                          widget.meetingData.likeYn == 'Y' ? 'N' : 'Y';

                      // TODO. 헤이즐. DB 처리
                    });
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  width: 220,
                  child: Text(widget.meetingData.meetingTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                ),
                background: Image.asset(
                  'images/background-meeting-001.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //];
            // },
            SliverFillRemaining(
              child: FutureBuilder(
                  future: _fetchUsers(context),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    if (data == null) {
                      return Text('데이터를 불러오는데 실패했습니다.');
                    }
                    users = initUsersIn(data);

                    return Container(
                      margin: kBodyMargin,
                      alignment: Alignment.centerLeft,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            //hasScrollBody: false,
                            child: Container(
                              // height: 200.0,
                              child: Column(
                                children: <Widget>[
                                  IconAndText(
                                    icon: Icons.date_range,
                                    title: widget.meetingData.meetingDate,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  IconAndText(
                                    icon: Icons.location_on,
                                    title: widget.meetingData.locationTitle,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  IconAndText(
                                    icon: Icons.account_balance_wallet,
                                    title: '모임 후 정산',
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  // 모임일시
                                  Container(
                                    height: 1,
                                    color: Color(0xffeeeeee),
                                  ),
                                  // 해시태그
                                  Container(
                                    child: Text(
                                      widget.meetingData.hashTags,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: kHashTagTextStyle,
                                    ),
                                  ),
                                  // 모임설명
                                  Container(
                                    width: 240,
                                    child: Text(
                                      widget.meetingData.description,
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                  // // 참석인원
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xffb7b7b7),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                    child: IconAndText(
                                      icon: Icons.group,
                                      title:
                                          '참석자(${users.length} / ${widget.meetingData.maxUserNum})',
                                    ),
                                  ),
                                  // 참석인원 영역
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var checkMeetingOrganizer = false;
                                if (widget.meetingData.organizerId ==
                                    users[index].id) {
                                  checkMeetingOrganizer = true;
                                }

                                return Participant(
                                  profileImageName: users[index].profileImgPath,
                                  participantName: users[index].name,
                                  gravityLevel: users[index].gravityVal,
                                  isMeetingOrganizer: checkMeetingOrganizer,
                                  isLiked: false,
                                  isBlackList: false,
                                );
                              },
                              childCount: users == null ? 0 : users.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: FutureBuilder(
                                future: getLocationIMap(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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

                                  return Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      widget.meetingData.locationAddress == ''
                                          ? Container()
                                          : Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '(${widget.meetingData.locationAddress})',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      locImage == null
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              //height: 50.0,
                                              child: locImage,
                                            ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
        bottomNavigationBar: FixedBottom(getButtonList(context)),
      );
    });
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      // 채팅하기 버튼
      Expanded(
        flex: 1,
        child: Builder(builder: (context) {
          return _isJoined
              ? MaterialButton(
                  onPressed: () {
                    print('userlist');
                    print(users);

                    Navigator.pushNamed(context, ChatScreen.id,
                        arguments:
                            ChatArgument(widget.meetingData.meetingId, users));
                  },
                  child: Icon(
                    Icons.chat,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  height: kBottomButtonSize,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 0.5)),
                )
              : MaterialButton(
                  onPressed: () {
                    print('userlist');
                    print(users);
                    Scaffold.of(context)
                        .showSnackBar(getSnackBar('모임에 참여하시면 채팅할 수 있어요'));
                  },
                  child: Icon(
                    Icons.chat,
                    color: Color(0xffb7b7b7),
                    size: 25.0,
                  ),
                  height: kBottomButtonSize,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xffb7b7b7), width: 0.5)),
                );
        }),
      ),
      /* SizedBox(
        width: 10.0,
      ),*/
      // 참여취소 버튼
      Expanded(
        flex: 4,
        child: _isJoined
            ? PostButton(
                text: '참여취소',
                onPressed: () {
                  print('참여취소하기');
                  // DB 삭제 처리
                  deleteUserMeeting();

                  _isJoined = false;
                  setState(() {
                    widget.meetingData.joinYn = 'N';
                  });
                },
              )
            : PostButton(
                text: '참여하기',
                onPressed: () {
                  print('참여하기');

                  // DB 입력 처리
                  createUserMeeting();

                  _isJoined = true;
                  setState(() {
                    widget.meetingData.joinYn = 'Y';
                  });
                },
              ),
      ),
    ];
  }

  // 모임 참여정보 입력
  Future createUserMeeting() async {
    print('createUserMeeting() start');

    // TODO : 모임참석 가능한 상태인지 확인
    print('users.length: ${users.length}');
    print('widget.meetingData.maxUserNum: ${widget.meetingData.maxUserNum}');

    if (users.length == widget.meetingData.maxUserNum) {
      print('모임 신청이 마감되었습니다.');
//      showAlertDialog(context);

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildJoinAlertDialog(context);
        },
      );
    } else {
      var bodyContents = {
        "meetingId": widget.meetingData.meetingId,
        "userId": myUser.id,
      };

      print('meetingId [${widget.meetingData.meetingId}]');
      print('userId [${myUser.id}]');

      var data = await _nodeConnector.postWithNonAuth(
          getkJoinMeetingPath(myUser.id, widget.meetingData.meetingId),
          bodyContents);

      /*
      User user = User();

      var userData = {
        'USER_ID': myUser.id,
        'USER_NM': myUser.name,
        'PROFILE_IMG_PATH': myUser.profileImgPath,
        'STAR_CODE': myUser.starCode,
        'COMPANY_ID': myUser.companyId,
        'GRAVITY_VALUE': myUser.gravityVal,
      };
      user.setUserInfo(userData);
      */

      setState(() {
        //   users.add(user);
      });
    }

    print('createUserMeeting() end');
  }

  // 모임 참여정보 삭제
  Future deleteUserMeeting() async {
    // print('deleteUserMeeting() start');
    //
    // print('users.length: ${users.length}');
    // print('widget.meetingData.maxUserNum: ${widget.meetingData.maxUserNum}');

    var bodyContents = {
      "meetingId": widget.meetingData.meetingId,
      "userId": myUser.id,
    };

    // print('meetingId [${widget.meetingData.meetingId}]');
    // print('userId [${myUser.id}]');

    var data = await _nodeConnector.deleteWithNonAuth(
        getkleaveMeetingPath(myUser.id, widget.meetingData.meetingId),
        bodyContents);

    setState(() {});

    print('deleteUserMeeting() end');
  }

  AlertDialog buildChatAlertDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        '모임에 참여하시면 채팅할 수 있어요',
        style: kAlertTitleTextStyle,
      ),
      content: Container(
//        height: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width / 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                '참여하기 버튼을 눌러 모임에 참여해보세요.',
                style: kAlertBodyTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Container(
                decoration: kUpperLineBoxDecoration,
                child: buildAlertButtons(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  AlertDialog buildJoinAlertDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        '모임 신청이 마감되었습니다.',
        style: kAlertTitleTextStyle,
      ),
      content: Container(
//        height: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width / 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                '다음에 다시 신청해주세요.',
                style: kAlertBodyTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Container(
                decoration: kUpperLineBoxDecoration,
                child: buildAlertButtons(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildAlertButtons(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Color(0xff4545f1),
                child: AlertButton(
                    text: '확인',
                    isCancel: false,
                    onTab: () {
                      Navigator.of(context).pop();
                    })),
          ),
        ],
      ),
    );
  }
}
