import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/location_data.dart';
import 'package:app/components/multiline_textformfield.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/search_location.dart';
import 'package:app/components/tab_controller_component.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/components/upload_photo_icon.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/interest.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/naver_api_connector.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/popup_layout.dart';
import 'package:app/screen/interest_icon_select_screen.dart';
import 'package:app/utils/method_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class MeetingPlanScreen extends StatefulWidget {
  static String id = '/meeting_plan_screen';
  final String interestCategoryTpcd;
  final String interestCategoryNm;

  Interest selectedInterest;
  // final int interestIconId;
  // final String imgPath;
  // final String interestNm;

  // final String interestCategoryTpcd = '2';
  // final String interestCategoryNm = 'test';
  // final int interestIconId = 2;
  // final String interestNm = 'test2';
  //
  MeetingPlanScreen(
      {Key key,
      this.interestCategoryTpcd,
      this.interestCategoryNm,
      this.selectedInterest})
      //  this.interestIconId,
      // this.interestNm,
      // this.imgPath})
      : super(key: key);

  @override
  _MeetingPlanScreenState createState() => _MeetingPlanScreenState();
}

//TODO : 수정하기
enum EntryFee {
  forFree,
  afterMeeting,
}

class _MeetingPlanScreenState extends State<MeetingPlanScreen> {
  NodeConnector _nodeConnector;
  MyUser myUser;

  int _organizerId = 0;
  String _interestCategoryTpcd = "";
  String _interestIconId = "";
  String _meetingNm = "";
  String _date = kHintTextDate;

  LocationData _locationData;
  String _numOfPeople = "";
  String _minEntryFee = "0";
  String _maxEntryFee = "0";
  String _description = "";
  Image mapImage = null;

  TextEditingController _dateCtrl = TextEditingController();
  TextEditingController _locCtrl = TextEditingController();
  TextEditingController _comtCtrl = TextEditingController();
  TextEditingController _meetTitleCtrl = TextEditingController();

  NaverAPIConnector naverAPIConnector = NaverAPIConnector();

  @override
  void initState() {
    super.initState();
    _nodeConnector = NodeConnector();
    _locationData = LocationData(
        title: kHintTextLoc, roadAddress: '', longitude: '', latitude: '');
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
          title: Text(
            '모임 만들기',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: BackButtonLeadingAppbar(),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              buildPrimeInfoForms(widget.interestCategoryNm),
              buildDetailInfoForms(),
            ],
          ),
        ),
        bottomNavigationBar: FixedBottom(getButtonList(context)),
      );
    });
  }

  Container buildPrimeInfoForms(String interestCategoryNm) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Color(0xffe8eaf6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            height: 18,
            width: 100,
            child: Text(
              // 모임 카테고리
              widget.interestCategoryNm,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff1ed69e),
              borderRadius: BorderRadius.all(
                Radius.circular(3),
              ),
            ),
          ),
          // 모임명
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _meetTitleCtrl,
                    onChanged: (value) {
                      if (value.length >= 40) {
                        setState(() {
                          _meetTitleCtrl.text = _meetingNm;
                        });
                        return;
                      }
                      _meetingNm = value;
                    },
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: '모임명을 입력하세요\n40자 이내',
                      hintStyle: TextStyle(
                        //letterSpacing: 5.0,
                        height: 1.2,
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '모임명을 입력하세요. (40자 이내)';
                      }
                      return null;
                    },
                  ),
                ),
                UploadPhotoIcon(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      PopupLayout(
                        child: InterestIconSelectScreen(
                            preScreen: MeetingPlanScreen.id),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        widget.selectedInterest = result;
                      });
                    }
                  },
                  image: Image.asset(widget.selectedInterest.image),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDetailInfoForms() {
    return Container(
      margin: kBodyMargin,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 모임일시
            SizedBox(
              height: 20.0,
            ),
            IconAndText(
              icon: Icons.date_range,
              title: '일시',
            ),
            UnderLineTextField(
              controller: _dateCtrl,
              hintText: kHintTextDate,
              readOnly: true,
              // textInputType: null,
              onTab: () {
                DatePicker.showDateTimePicker(context,
                    theme: DatePickerTheme(
                      containerHeight: 210.0,
                    ),
                    showTitleActions: true,
                    minTime: DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day),
                    // maxTime: DateTime(2020, 12, 31), onConfirm: (date) {
                    maxTime: DateTime(
                        DateTime.now().year,
                        DateTime.now().month +
                            kMeetingPlanMonth, // 향후 3개월까지 설정 가능
                        DateTime.now().day), onConfirm: (date) {
                  try {
                    _date = '${date.year}' +
                        '.' +
                        '${date.month}'.padLeft(2, "0") +
                        '.' +
                        '${date.day}'.padLeft(2, "0") +
                        ' ' +
                        '${date.hour}'.padLeft(2, "0") +
                        ':' +
                        '${date.minute}'.padLeft(2, "0");
                  } on Exception catch (e, s) {
                    print(s);
                  }
                  setState(() {
                    _dateCtrl.text = _date;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.ko);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            IconAndText(
              icon: Icons.location_on,
              title: '장소',
            ),
            SizedBox(
              height: 10.0,
            ),
            UnderLineTextField(
              controller: _locCtrl,
              hintText: kHintTextLoc,
              readOnly: true,
              // textInputType: null,
              onTab: () async {
                var result = await Navigator.of(context).push(_createRoute());
                if (result != null) {
                  _locationData = result;

                  Image locImage = null;
                  if (_locationData.longitude != '') {
                    print(_locationData.longitude);
                    print(_locationData.latitude);
                    locImage = await naverAPIConnector.getLocationIMap(
                        _locationData.longitude,
                        _locationData.latitude,
                        kNaverMapClientIdKeyword,
                        kNaverMapClientSecretKeyword);
                    //locImage = await _getMapImage(locData.mapX, locData.mapY);
                  }
                  setState(() {
                    mapImage = locImage;
                    _locCtrl.text = _locationData.title;
                  });
                }
              },
            ),
            // Container(),
            SizedBox(
              height: 10.0,
            ),
            _locationData.roadAddress == ''
                ? Container()
                : Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '(${_locationData.roadAddress})',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
            mapImage == null
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width - 40,
                    //height: 50.0,
                    child: mapImage,
                  ),
            SizedBox(
              height: 20.0,
            ),
            IconAndText(
              icon: Icons.group,
              title: '인원',
            ),
            //TODO : 숫자타입 키보드는 정규식으로 숫자만 입력한것 체크
            UnderLineTextField(
              hintText: kHhintTextNumOfPeople,
              textInputType: TextInputType.number,
              onChanged: (value) {
                _numOfPeople = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '..';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            IconAndText(
              icon: Icons.account_balance_wallet,
              title: '회비',
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildEntryFee(),
            ),
            selectedEntryFee == EntryFee.forFree
                ? Container()
                : SizedBox(
                    height: 20.0,
                  ),
            selectedEntryFee == EntryFee.forFree
                ? Container()
                : IconAndText(
                    icon: Icons.attach_money,
                    title: '회비 범위(원)',
                  ),
            selectedEntryFee == EntryFee.forFree
                ? Container()
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      UnderLineTextField(
                        hintText: '최소금액',
                        textInputType: TextInputType.number,
                        onChanged: (minValue) {
                          _minEntryFee = minValue;
                        },
                        width: 150,
                        validator: (minValue) {
                          if (minValue.isEmpty) {
                            return '0';
                          }
                          return null;
                        },
                      ),
                      Text(
                        '~',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      UnderLineTextField(
                        hintText: '최대금액',
                        textInputType: TextInputType.number,
                        onChanged: (maxValue) {
                          _maxEntryFee = maxValue;
                        },
                        width: 150,
                        validator: (maxValue) {
                          if (maxValue.isEmpty) {
                            return '0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
            SizedBox(
              height: 20.0,
            ),
            IconAndText(
              icon: Icons.chat_bubble_outline,
              title: '코멘트',
            ),
            CustomTextFormField(
              controller: _comtCtrl,
              hintText: kHhintTextComment,
              onChanged: (value) {
                if (value.length >= 2500) {
                  setState(() {
                    _comtCtrl.text = _description;
                  });

                  return;
                }
                _description = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '포스트하기',
          onPressed: () {
            print('call createMeetingPlan');
            _interestCategoryTpcd = widget.interestCategoryTpcd;
            _interestIconId = widget.selectedInterest.interestIconId.toString();

            // DB 입력 처리
            createMeetingPlan();
          },
        ),
      ),
    ];
  }

  // 회비 선택 버튼
  EntryFee selectedEntryFee = EntryFee.forFree;

  List<Widget> buildEntryFee() {
    List<Widget> buttons = List<Widget>();

    Map<EntryFee, String> entryFeeText = {
      EntryFee.forFree: '없음',
      EntryFee.afterMeeting: '모임후 정산',
    };

    for (EntryFee entryFee in EntryFee.values) {
      buttons.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  selectedEntryFee = entryFee;
                });
              },
              child: Text(
                entryFeeText[entryFee],
                style: TextStyle(),
              ),
              textColor:
                  selectedEntryFee == entryFee ? Colors.white : Colors.black,
              color: selectedEntryFee == entryFee
                  ? Color(0xff1ed69e)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xffb7b7b7), width: 0.5)),
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  Future createMeetingPlan() async {
    print('createMeetingPlan() start');

    // 로그인한 User 정보 조회
    _organizerId = myUser.id;

    print('_organizerId : $_organizerId');
    print('interestCategoryTpcd : $_interestCategoryTpcd');
    print('interestIconId : $_interestIconId');
    print('meetingNm : $_meetingNm');

    var bodyContents = {
      "organizerId": _organizerId,
      "interestCategoryTpcd": _interestCategoryTpcd,
      "interestIconId": _interestIconId,
      "meetingNm": _meetingNm,
      "date": _date,
      "numOfPeople": _numOfPeople,
      "minEntryFee": _minEntryFee,
      "maxEntryFee": _maxEntryFee,
      "description": _description,
      "locTitle": _locationData.title,
      "locAddr": _locationData.roadAddress,
      "longitude": _locationData.longitude,
      "latitude": _locationData.latitude,
    };

    var data =
        await _nodeConnector.postWithNonAuth(kCreateMeetingPlan, bodyContents);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TabControllerComponent()));

    print('createMeetingPlan() end');
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchLoaction(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
