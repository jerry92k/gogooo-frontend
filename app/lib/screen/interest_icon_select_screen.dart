import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/post_button.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/components/interest_icon.dart';
import 'package:app/model/interest.dart';
import 'package:app/model/interest_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/meeting_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class InterestIconSelectScreen extends StatefulWidget {
  static String id = '/interest_icon_select_screen';
  final String interestCategoryId;
  final String interestCategoryNm;
  final String preScreen;

  const InterestIconSelectScreen(
      {Key key,
      this.interestCategoryId,
      this.interestCategoryNm,
      this.preScreen})
      : super(key: key);

  @override
  _InterestIconSelectScreenState createState() =>
      _InterestIconSelectScreenState();
}

class _InterestIconSelectScreenState extends State<InterestIconSelectScreen> {
  List<Map<String, String>> buildMeetingIconList;
  int counter = 999;
  FlutterSecureStorage _storage;
  NodeConnector _nodeConnector;
  // int selectedInterestIconId = 0;
  //String selectedInterestNm = "";
  //String selectedInstImg = '';
  //selectedInstImg

  List<Interest> _interestList = [];

  Interest selectedInterest;

  @override
  void initState() {
    _storage = FlutterSecureStorage();
    _nodeConnector = NodeConnector();
    // futureFetch = _fetchInterestIcons();
    super.initState();
    //parseMeetingIcons();
  }

  bool isInit = true;
  //var futureFetch;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _fetchInterestIcons(),
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

          if (data == null) {
            return Text('데이터를 불러오는데 실패했습니다.');
          }

          _interestList = data;
          isInit = false;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffffffff),
            brightness: Brightness.light,
            elevation: 0.0,
            title: Text(
              '모임 이미지 선택',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            leading: BackButtonLeadingAppbar(),
            centerTitle: true,
          ),
          body: getCategoryGrid(),
          bottomNavigationBar: FixedBottom(getButtonList(context)),
        );
      },
    );
  }

  Widget getCategoryGrid() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        // height: 350.0,
        width: 350.0,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: _interestList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            //   crossAxisSpacing: 42.0,
            // mainAxisSpacing: 2.0,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            var interest = _interestList[index];

            InterestIcon interestIcon = new InterestIcon(
              image: interest.image,
              interestIconId: interest.interestIconId,
              // interestId: interest.interestId,
              interestNm: interest.interestNm,
              isSelected: interest.isSelected,
              onSelectedCallback: () {
                print(
                    'InterestIconSelectScreen InterestIcon.onSelectedCallback()');

                selectedInterest = interest;
                //selectedInterestIconId = interest.interestIconId;
                // selectedInterestNm = interest.interestNm;
                //selectedInstImg = interest.image;
                updateSelection(interest);
              },
            );
            return interestIcon;
          },
        ),
      ),
    );
  }

  Future _fetchInterestIcons() async {
    if (!isInit) {
      return null;
    }
    var data = await _nodeConnector.getWithNonAuth(kGetInterestIcons);
    var meetingIconsData = data[0]["results"];
    var parsed = meetingIconsData.cast<Map<String, dynamic>>();

    return parsed.map<Interest>((json) => Interest.fromJson(json)).toList();
  }

  void updateSelection(Interest selectedInterest) {
    for (Interest interest in _interestList) {
      if (selectedInterest.interestIconId == interest.interestIconId) {
        interest.isSelected = true;
        //     notifyListeners();
      } else {
        interest.isSelected = false;
        // notifyListeners();
      }
    }
    setState(() {});
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '선택',
          onPressed: () {
            if (selectedInterest == null) {
              return; // 스타벅스
            }
            if (widget.preScreen == MeetingPlanScreen.id) {
              Navigator.pop(context, selectedInterest);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MeetingPlanScreen(
                          interestCategoryTpcd: widget.interestCategoryId,
                          interestCategoryNm: widget.interestCategoryNm,
                          selectedInterest: selectedInterest,
                          // interestIconId: selectedInterestIconId,
                          // interestNm: selectedInterestNm,
                          //  imgPath: selectedInstImg,
                        )),
              );
            }
          },
        ),
      ),
    ];
  }
}
