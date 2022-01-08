import 'package:app/components/dropdown.dart';
import 'package:app/components/feed_item.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/popup_layout.dart';
import 'package:app/screen/feed_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static String id = '/feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final double favoriteSize = 15.0;

  final double notificationSize = 30.0;

  int counter = 1;

  bool isInit = true;

  MyUser myUser;

  NodeConnector _nodeConnector;

  //List<FeedData> FeedDataList;
  int lastIdx = 1;

  ScrollController _controller;
  @override
  void initState() {
    // TODO: implement initState

    _nodeConnector = NodeConnector();

    //리스트뷰 컨트롤
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    // if (_controller.offset >= _controller.position.maxScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   print(FeedDataList.length);
    //   lastIdx = FeedDataList.length + 1;
    //
    //   fetchMeetMoreDatas(false);
    //   //  });
    // } else if (_controller.offset <= _controller.position.minScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   lastIdx = 1;
    //
    //   fetchMeetMoreDatas(true);
    //   //setState(() {
    //   // message = "reach the top";
    //   // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return Consumer<MyUserData>(builder: (context, myUserData, child) {
    //   myUser = myUserData.myUser;
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //         backgroundColor: Colors.white,
    //         brightness: Brightness.light,
    //         elevation: 0.0,
    //         title: Text(
    //           '피드',
    //           style: TextStyle(
    //             fontSize: 20,
    //             color: Colors.black,
    //           ),
    //         ),
    //         centerTitle: true,
    //         actions: <Widget>[
    //           Stack(
    //             children: <Widget>[
    //               new IconButton(
    //                   icon: Icon(
    //                     Icons.search,
    //                     color: Colors.black,
    //                     size: 30.0,
    //                   ),
    //                   tooltip: 'Search',
    //                   onPressed: () {
    //                     setState(() {
    //                       counter = 0;
    //                     });
    //                     //TODO : 검색어로 피드에서 찾기
    //                   }),
    //             ],
    //           ),
    //         ]),
    //     body: FutureBuilder(
    //         future: fetchFeedDatas(),
    //         builder: (BuildContext context, AsyncSnapshot snapshot) {
    //           if (isInit) {
    //             //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
    //             if (snapshot.hasData == false) {
    //               return CircularProgressIndicator();
    //             }
    //             //error가 발생하게 될 경우 반환하게 되는 부분
    //             else if (snapshot.hasError) {
    //               return Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   'Error: ${snapshot.error}',
    //                   style: TextStyle(fontSize: 15),
    //                 ),
    //               );
    //             }
    //             var data = snapshot.data;
    //
    //             FeedDataList = data
    //                 .map<FeedData>((json) => FeedData.fromJson(json))
    //                 .toList();
    //             isInit = false;
    //           }
    //
    //           return Container(
    //             child: Column(
    //               children: [
    //                 Row(
    //                   children: buildTpcd(),
    //                 ),
    //                 /*
    //           ListView(
    //             shrinkWrap: true,
    //             padding: const EdgeInsets.fromLTRB(5, 10, 5, 80),
    //             children: <Widget>[
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: <Widget>[
    //                   // 검색필터 영역
    //                   Row(
    //                     children: buildTpcd(),
    //                   ),
    //                   // 모임 영역
    //                   FeedItem(
    //                     profileImageName: 'images/profile-icon/cha_jupiter_1.png',
    //                     participantName: '뽐내는 주피터',
    //                     image:
    //                         'https://lh3.googleusercontent.com/proxy/9e_tsKiDUfmIrSJ0OVHeUaJQbI2ZpYaQEfP02s1weH1KkR5puNdNMFdDJZhwbTtsffdo_HkhHtzcRl9pgqEHnfRkvxSWGHskKNDJj7FOqJ0BepTcw26qzExX7SUAK8duns36jfC9CnaKRN-QKE_ZMSWRhUqZ',
    //                     isLiked: false,
    //                     interestNm: '맛집',
    //                     hashTags: '＃맛집 #브런치',
    //                     experience:
    //                         '''부산시립미술관에서 전시회 관람 후, 6명 멤버들은 다같이 맛있는 오믈렛을 먹었어요~!! 즐거운 시간을 보내고 나니 행복하군요! 매일매일 먹고 싶아요. 브런치 ㅋㅋ ''',
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),*/
    //               ],
    //             ),
    //           );
    //         }),
    //     floatingActionButton: FloatingActionButton(
    //       // 모임 만들기 화면
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           PopupLayout(
    //             child: FeedPostScreen(),
    //           ),
    //         );
    //       },
    //       backgroundColor: Color(0xff4545f1),
    //       child: Icon(
    //         Icons.add,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // });
  }

  Future fetchFeedDatas() async {
    // if (!isInit) {
    //   // return null;
    // }
    //
    // if (myUser == null) {
    //   // 유저 정보 없으면 오류.
    //   return null;
    // }
    //
    // var data = await _nodeConnector.getWithNonAuth(kMaxMeetId);
    // var resultData = data[0]["results"];
    // if (resultData == null) {
    //   print('max meet id is null');
    //   return null;
    // }
    // //단건 리턴
    // maxMeetId = resultData['MAX_MEET_ID'];
    //
    // data = await _nodeConnector
    //     .getWithNonAuth(getkMeetList(myUser.id, maxMeetId, lastIdx));
    // resultData = data[0]["results"];
    //
    // if (resultData == null) {
    //   print('here null');
    //   return null;
    // }
    //
    // print('resultData');
    // print(resultData);
    // var parsed = resultData.cast<Map<String, dynamic>>();
    //
    // return parsed;
  }

  FeedTpcd selectedFeedTpcd = FeedTpcd.all;

  Map<FeedTpcd, String> genderText = {
    FeedTpcd.all: '전체',
    FeedTpcd.review: '후기',
    FeedTpcd.life: '일상',
    FeedTpcd.info: '정보',
  };

  List<Widget> buildTpcd() {
    List<Widget> buttons = List<Widget>();

    for (FeedTpcd tpcd in FeedTpcd.values) {
      buttons.add(
        Container(
          height: 30.0,
          width: 80.0,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: FlatButton(
            onPressed: () {
              setState(() {
                selectedFeedTpcd = tpcd;
                // print('selectedGender : $selectedGender');
              });

              //TODO : 정보 다시 불러오는 요청
            },
            child: Text(
              genderText[tpcd],
              style: TextStyle(),
            ),
            textColor:
                selectedFeedTpcd == tpcd ? Colors.white : Color(0xff000000),
            color: selectedFeedTpcd == tpcd ? Color(0xff1ed69e) : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xffb7b7b7), width: 0.5)),
          ),
        ),
      );
    }

    return buttons;
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
}

enum FeedTpcd { all, review, life, info }

/*
<댓글 알고리즘> - 2단계 이상의 구조를 가질때 아래와 같이 사용하면 좋을것 같음.
현재는 대댓글까지 하면 되므로 알고리즘까지 쓸필요 없다고 판단함

FEED_ID ID UPPER_ID ORDER MAX_GROUP_ORDER WRITER_ID ALT_TPCD LAST_MODF_DTTM
1) 상위댓글번호 가서 해당 댓글로우의 제일큰순서를 가져옴 O(1)
2)가져온 제일큰순서 +1 => 내 댓글 로우 순서 및 내 댓글로우그룹에서 제일 큰 순서로 셋팅 O(1)
3) 해당 순서보다 큰 순서들은 다 +1해줌 O(n)
4)상위 댓글번호에 제일 큰 순서를 나로 바꿈. 바꾼값을 루트 or 멈출때까지 나올때까지 비교해나가면서 변경해줌. update함.O(log2n)
 */
