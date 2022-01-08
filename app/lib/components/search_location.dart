import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/location_data.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/question_text.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/constants/constants.dart';
import 'package:app/network/kakao_api_connector.dart';
import 'package:app/network/naver_api_connector.dart';
import 'package:flutter/material.dart';

class SearchLoaction extends StatefulWidget {
  static String id = '/search_location';

  @override
  _SearchLoactionState createState() => _SearchLoactionState();
}

class _SearchLoactionState extends State<SearchLoaction> {
  bool isSearch = false;

  String _keyword = '';

  String locTitle = '';
  String locAddr = '';

  TextEditingController _keywordCtrl = TextEditingController();
  TextEditingController _dirInputCtrl = TextEditingController();

  List<LocationData> locList = [];

  NaverAPIConnector naverAPIConnector = NaverAPIConnector();

  int selectedIndex = -1;

  bool isShowInputBox = false;

  bool isShowDirQuest = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
        title: UnderLineTextField(
          controller: _keywordCtrl,
          hintText: '[예시: 수영구 스타벅스]',
          onChanged: (value) {
            setState(() {
              _keyword = value;
            });
          },
          suffixIcon: IconButton(
            icon: Icon(
              Icons.cancel,
              size: 20.0,
              color: Color(0xffb7b7b7),
            ),
            onPressed: () {
              setState(() {
                _keyword = '';
                _keywordCtrl.text = _keyword;
                isShowDirQuest = true;
                locList.clear();
              });
            },
          ),
        ),
        leading: BackButtonLeadingAppbar(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchLocation();
            },
          )
        ],
        titleSpacing: 0.0,
        leadingWidth: 30.0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: locList == null ? 0 : locList.length,
////: title = json['title'].toString().replaceAll(r'(<b>|</b>)', ''),
                //controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    //    height: 200.0,
                    decoration: BoxDecoration(
                      border: Border(
                        // top: BorderSide(width: 0.1, color: Color(0xffeeeeee)),
                        // top: BorderSide(width: 0.5, color: Colors.black),
                        bottom:
                            //BorderSide(width: 0.5, color: Colors.black),
                            BorderSide(width: 1.0, color: Color(0xffeeeeee)),
                      ),
                    ),
                    child: RadioListTile(
                      groupValue: selectedIndex,
                      title: Text(
                        locList[index].title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(locList[index].roadAddress),
                      activeColor: Colors.black,
                      value: index,
                      onChanged: (val) {
                        setState(() {
                          selectedIndex = val;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: isShowDirQuest ? 20.0 : 0.0,
            // height: 20.0,
          ),
          isShowDirQuest
              ? QuestionText(
                  onTab: () async {
                    setState(() {
                      selectedIndex = -1;
                      isShowInputBox = true;
                      locList.clear();
                      _keyword = '';
                      _keywordCtrl.text = _keyword;
                    });
                    FocusScope.of(context).unfocus();
                    //  Navigator.of(context).push(_createRoute());
                  },
                  text: '직접 입력하실래요? >',
                )
              : Container(),
          SizedBox(
            height: isShowInputBox ? 200.0 : 0.0,
            //height: 20.0,
          ),
          isShowInputBox
              ? UnderLineTextField(
                  controller: _dirInputCtrl,
                  hintText: '장소를 직접 입력해주세요',
                )
              : Container(),
        ],
      ),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '적용하기',
          onPressed: () async {
            // print(locList[selectedIndex].title);
            if (selectedIndex >= 0) {
              Navigator.pop(context, locList[selectedIndex]);
            }

            if (_dirInputCtrl.text != '') {
              LocationData locData = LocationData(
                  title: _dirInputCtrl.text,
                  roadAddress: '',
                  longitude: '',
                  latitude: '');
              Navigator.pop(context, locData);
            }
          },
        ),
      ),
    ];
  }

  //TODO : 하단으로 내렸을때, 페이지 나눠서 더 읽어오도록... 추후 수정
  // https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-keyword
  Future<void> _searchLocation() async {
    //String keyword = 'bifc 카페051';
    if (_keyword.isEmpty) {
      return;
    }
    locList.clear();
    KakaoApiConnector kakaoApiConnector = KakaoApiConnector();
    var data = await kakaoApiConnector.searchByKeyword(_keyword);
    print(data);

    var documents = data['documents'];

    setState(() {
      locList.addAll(documents
          .map<LocationData>((json) => LocationData.fromJson(json))
          .toList());
      selectedIndex = -1;
      isShowInputBox = false;
      isShowDirQuest = false;
    });

    // String apiURL =
    //     'https://openapi.naver.com/v1/search/local.json?query=$_keyword&display=5&start=1&sort=sim'; // json 결과
    // naverAPIConnector.setURL(apiURL);
    //
    // var locationData = await naverAPIConnector.searchLoactions(
    //     kNaverSearchClientIdKeyword, kNaverSearchClientSecretKeyword);
    //
    // print('here test');
    // print(locationData);
    // int count = locationData['total'];
    // var locDataList = locationData['items'];
    //
    // setState(() {
    //   locList.addAll(locDataList
    //       .map<LocationData>((json) => LocationData.fromJson(json))
    //       .toList());
    //   selectedIndex = -1;
    //   isShowInputBox = false;
    // });
    FocusScope.of(context).unfocus();
  }
}
