import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/question_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/constants.dart';
import 'package:app/components/star_profile_row.dart';
import 'package:app/components/profile_icon_item.dart';
import 'package:app/model/profile_icon.dart';
import 'package:app/model/profile_icon_data.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/popup_layout.dart';
import 'package:app/screen/enroll_profile_step2_screen.dart';
import 'package:app/screen/star_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrollProfileStep1Screen extends StatefulWidget {
  static String id = '/enroll_profile_step1_screen';

  @override
  _EnrollProfileStep1ScreenState createState() =>
      _EnrollProfileStep1ScreenState();
}

class _EnrollProfileStep1ScreenState extends State<EnrollProfileStep1Screen> {
  List<ProfileIcon> profileIconList;
  NodeConnector _nodeConnector;

  ProfileIcon _selectedProfileIcon;

  @override
  void initState() {
    // TODO: implement initState
    _nodeConnector = NodeConnector();
    _selectedProfileIcon = ProfileIcon();
    //   futureFetch = _fetchProfileIconItems();
    super.initState();
  }

  //var futureFetch;
  bool isInit = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '기본정보 입력',
        ),
        leading: BackButtonLeadingAppbar(),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fetchProfileIconItems(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print('is here inside?');
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
              print('data');
              print(data);
              profileIconList = data;
              print('here future started ');
            }
            isInit = false;
            return Container(
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRichText(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '나의 행성 선택',
                          style: kEnrollProfileCategoryTextStyle,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(
                              Icons.help_outline,
                              size: 20.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PopupLayout(
                                  child: StarProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 15.0,
                  ),
                  getCategoryGrid(),
                ],
              ),
            );
          }),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  Widget getCategoryGrid() {
    return Expanded(
      child: Container(
        //height: 350.0,
        width: 300.0,
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: profileIconList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            var profileIcon = profileIconList[index];

            ProfileIconItem myProfileIcon = new ProfileIconItem(
              profileIconId: profileIcon.profileIconId,
              profileNm: profileIcon.profileNm,
              image: profileIcon.profileImgFileNm,
              isSelected: profileIcon.isSelected,
              onSelectedCallback: () {
                _selectedProfileIcon = profileIcon;

                updateSelection(profileIcon);
              },
            );
            return myProfileIcon;
          },
        ),
      ),
    );
  }

  void updateSelection(ProfileIcon profileIcon) {
    for (ProfileIcon vo in profileIconList) {
      if (vo.profileIconId == profileIcon.profileIconId) {
        vo.isSelected = true;
      } else {
        vo.isSelected = false;
      }
    }
    setState(() {});
  }

  RichText buildRichText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'STEP 1',
            style: kLightTextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: '/3',
            style: kLightTextStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '다음',
          onPressed: () {
            Navigator.pushNamed(context, EnrollProfileStep2Screen.id,
                arguments: Step1Arguments(_selectedProfileIcon));
          },
        ),
      ),
    ];
  }

  Future _fetchProfileIconItems() async {
    if (!isInit) {
      return null;
    }

    var data = await _nodeConnector.getWithNonAuth(kGetProfileIcons);

    var profileIconsData = data[0]["results"];
    var parsed = profileIconsData.cast<Map<String, dynamic>>();

    return parsed
        .map<ProfileIcon>((json) => ProfileIcon.fromJson(json))
        .toList();
  }
}
