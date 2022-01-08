import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/interest_category_item.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/tab_controller_component.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/interest_category.dart';
import 'package:app/model/interest_category_data.dart';
import 'package:app/model/profile_icon.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/utils/method_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrollProfileStep3Screen extends StatefulWidget {
  static String id = '/enroll_profile_step3_screen';

  @override
  _EnrollProfileStep3ScreenState createState() =>
      _EnrollProfileStep3ScreenState();
}

class _EnrollProfileStep3ScreenState extends State<EnrollProfileStep3Screen> {
  //Map<String, bool> hobbies;

  @override
  void initState() {
    _nodeConnector = NodeConnector();
    super.initState();
    //futureFetch = _fetchInterestCategoryItems();
    //  initHobbyMap();
  }

  NodeConnector _nodeConnector;
  // var futureFetch;
  Step2Arguments step2Arguments;

  List<InterestCategory> categoryList = [];

  void getArgument(BuildContext context) {
    step2Arguments = ModalRoute.of(context).settings.arguments;
  }

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    getArgument(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '기본정보 입력',
        ),
        leading: BackButtonLeadingAppbar(),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fetchInterestCategoryItems(),
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

              categoryList = data;
            }
            isInit = false;

            return Container(
              margin: kBodyMargin,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRichText(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '관심분야 선택',
                    style: kEnrollProfileCategoryTextStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  getCategoryGrid(),
                ],
              ),
            );
          }),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  Future _fetchInterestCategoryItems() async {
    if (!isInit) {
      return;
    }
    var data = await _nodeConnector.getWithNonAuth(kGetInterestCategoryList);
    var interestCategoryData = data[0]["results"];
    if (interestCategoryData == null) {
      return null;
    }
    var parsed = interestCategoryData.cast<Map<String, dynamic>>();
    return parsed
        .map<InterestCategory>((json) => InterestCategory.fromJson(json))
        .toList();
  }

  void updateSelection() {
    setState(() {});
  }

  Widget getCategoryGrid() {
    return Container(
      height: 350.0,
      width: 400.0,
      child: GridView.builder(
        itemCount: categoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          String basePath = "images/interest-icons/";

          var interestCategory = categoryList[index];

          InterestCategoryItem interestCategoryItem = new InterestCategoryItem(
            interestCategoryId: interestCategory.interestCategoryId,
            // interestId: interest.interestId,
            interestCategoryNm: interestCategory.interestCategoryNm,
            isSelected: interestCategory.isSelected,
            onSelectedCallback: () {
              print('here inside category');
              print(
                  'InterestCategorySelectScreen InterestCategory.onSelectedCallback()');
              categoryList[index].isSelected = !categoryList[index].isSelected;
              updateSelection();
            },
          );
          return interestCategoryItem;
        },
      ),
    );
  }

  Container buildFieldLabel(String label) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        label,
        style: kFieldTitleTextStyle,
      ),
    );
  }

  RichText buildRichText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'STEP 3',
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
        child: new Builder(builder: (BuildContext snackContext) {
          return PostButton(
            text: '시작하기',
            onPressed: () {
              print('selectedData');
              List<String> interestList = [];
              for (InterestCategory categoryItem in categoryList) {
                if (categoryItem.isSelected) {
                  interestList.add(categoryItem.interestCategoryId);
                }
              }
              if (interestList.length <= 0) {
                Scaffold.of(snackContext)
                    .showSnackBar(getSnackBar('관심 카테고리를 최소 1개 선택해주세요.'));
                return;
              }

              createUserProfile(interestList);
              // Navigator.pushNamed(context, TabControllerComponent.id);
            },
          );
        }),
      ),
    ];
  }

  Future createUserProfile(List<String> interestList) async {
    print('createUserProfile() start');

    var bodyContents = {
      "PROFILE_ICON_ID": step2Arguments.profileIcon.profileIconId,
      "NAME": step2Arguments.name,
      "SEX": step2Arguments.sex,
      "interests": interestList,
    };
    print('body Data');
    print(bodyContents);

    var data =
        await _nodeConnector.postWithAuth(kCreateUserProfile, bodyContents);

    print(data);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TabControllerComponent()));

    print('createMeetingPlan() end');
  }
}

class Step2Arguments {
  final ProfileIcon profileIcon;
  final String name;
  final String sex; // F:여성, M:남성, S:행성

  Step2Arguments({this.profileIcon, this.name, this.sex});
}
