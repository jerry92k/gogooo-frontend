import 'package:app/components/fixed_bottom.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/post_button.dart';
import 'package:app/screen/interest_icon_select_screen.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/components/interest_category_item.dart';
import 'package:app/model/interest_category.dart';
import 'package:app/model/interest_category_data.dart';
import 'package:app/model/interest_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/meeting_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class InterestCategorySelectScreen extends StatefulWidget {
  static String id = '/category_select_screen';

  NodeConnector _nodeConnector;

  @override
  _InterestCategorySelectScreenState createState() =>
      _InterestCategorySelectScreenState();
}

class _InterestCategorySelectScreenState
    extends State<InterestCategorySelectScreen> {
  List data = [];
  List<InterestCategory> interestCategories;
  int counter = 999;
  FlutterSecureStorage _storage;
  NodeConnector _nodeConnector;
  String selectedInterestCategoryId = "";
  String selectedInterestCategoryNm = "";

  @override
  void initState() {
    super.initState();

    _storage = FlutterSecureStorage();
    _nodeConnector = NodeConnector();

    //parseMeetingIcons();
    //futureFetch = _fetchInterestCategoryItems();
  }

  //var futureFetch;

  List<InterestCategory> categoryList = [];

  Future _fetchInterestCategoryItems() async {
    if (!isInit) {
      return null;
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
    //var data = await _fetchInterestCategoryItems();

    // 토큰 만료 체크 후 필요시 리프레시
    //await _nodeConnector.refreshIfNeed();
  }

  bool isInit = true;
  @override
  Widget build(BuildContext context) {
    //  var parsed = await parseMeetingIcons();
    //  return Consumer<InterestCategoryData>(
    //  builder: (context, interestCategoryData, child) {
    return FutureBuilder(
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
          isInit = false;
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffffffff),
            brightness: Brightness.light,
            elevation: 0.0,
            title: Text(
              '카테고리 선택',
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
        margin: kBodyMargin,
        alignment: Alignment.center,
        width: 360.0,
        child: GridView.builder(
          itemCount: categoryList.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            //   crossAxisSpacing: 5.0,
            //   mainAxisSpacing: 5.0,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            String basePath = "images/interest-icons/";

            var interestCategory = categoryList[index];

            InterestCategoryItem interestCategoryItem =
                new InterestCategoryItem(
              interestCategoryId: interestCategory.interestCategoryId,
              // interestId: interest.interestId,
              interestCategoryNm: interestCategory.interestCategoryNm,
              isSelected: interestCategory.isSelected,
              onSelectedCallback: () {
                print(
                    'InterestCategorySelectScreen InterestCategory.onSelectedCallback()');

                selectedInterestCategoryId =
                    interestCategory.interestCategoryId;
                selectedInterestCategoryNm =
                    interestCategory.interestCategoryNm;
                updateSelection(interestCategory);
                print(
                    'selectedInterestCategoryTitle : [${selectedInterestCategoryId}] ${selectedInterestCategoryNm}');
              },
            );
            return interestCategoryItem;
          },
        ),
      ),
    );
  }

  void updateSelection(InterestCategory selectedInterestCategory) {
    for (InterestCategory interestCategory in categoryList) {
      if (selectedInterestCategory.interestCategoryId ==
          interestCategory.interestCategoryId) {
        interestCategory.isSelected = true;
      } else {
        interestCategory.isSelected = false;
      }
    }
    setState(() {});
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '다음',
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InterestIconSelectScreen(
                        preScreen: InterestCategorySelectScreen.id,
                        interestCategoryId: selectedInterestCategoryId,
                        interestCategoryNm: selectedInterestCategoryNm,
                      )),
            );
          },
        ),
      ),
    ];
  }
}

// import 'package:app/constants/routes_constants.dart';
// import 'package:app/components/back_button_leading_appbar.dart';
// import 'package:app/components/post_button.dart';
// import 'package:app/screen/interest_icon_select_screen.dart';
// import 'package:app/utils/method_utils.dart';
// import 'package:app/components/interest_category_item.dart';
// import 'package:app/model/interest_category.dart';
// import 'package:app/model/interest_category_data.dart';
// import 'package:app/model/interest_data.dart';
// import 'package:app/network/node_connector.dart';
// import 'package:app/screen/meeting_plan_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:provider/provider.dart';
//
// class InterestCategorySelectScreen extends StatefulWidget {
//   static String id = '/category_select_screen';
//
//   NodeConnector _nodeConnector;
//
//   @override
//   _InterestCategorySelectScreenState createState() =>
//       _InterestCategorySelectScreenState();
// }
//
// class _InterestCategorySelectScreenState
//     extends State<InterestCategorySelectScreen> {
//   List data = [];
//   List<InterestCategory> interestCategories;
//   int counter = 999;
//   FlutterSecureStorage _storage;
//   NodeConnector _nodeConnector;
//   String selectedInterestCategoryId = "";
//   String selectedInterestCategoryNm = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     _storage = FlutterSecureStorage();
//     _nodeConnector = NodeConnector();
//     //parseMeetingIcons();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //  var parsed = await parseMeetingIcons();
//     return Consumer<InterestCategoryData>(
//       builder: (context, interestCategoryData, child) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xffffffff),
//             brightness: Brightness.light,
//             elevation: 0.0,
//             title: Text(
//               '카테고리 선택',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.black,
//               ),
//             ),
//             leading: BackButtonLeadingAppbar(),
//             centerTitle: true,
//           ),
//           body: GridView.builder(
//             itemCount: interestCategoryData.interestCategoryCount,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 5.0,
//               mainAxisSpacing: 5.0,
//               childAspectRatio: 2.5,
//             ),
//             itemBuilder: (BuildContext context, int index) {
//               String basePath = "images/interest-icons/";
//
//               var interestCategory =
//                   interestCategoryData.interestCategories[index];
//
//               InterestCategoryItem interestCategoryItem =
//                   new InterestCategoryItem(
//                 interestCategoryId: interestCategory.interestCategoryId,
//                 // interestId: interest.interestId,
//                 interestCategoryNm: interestCategory.interestCategoryNm,
//                 isSelected: interestCategory.isSelected,
//                 onSelectedCallback: () {
//                   print(
//                       'InterestCategorySelectScreen InterestCategory.onSelectedCallback()');
//
//                   selectedInterestCategoryId =
//                       interestCategory.interestCategoryId;
//                   selectedInterestCategoryNm =
//                       interestCategory.interestCategoryNm;
//                   interestCategoryData.updateSelectedToggle(interestCategory);
//
//                   print(
//                       'selectedInterestCategoryTitle : [${selectedInterestCategoryId}] ${selectedInterestCategoryNm}');
//                 },
//               );
//               return interestCategoryItem;
//             },
//           ),
//           bottomNavigationBar: buildFixedBottomButtons(getButtonList(context)),
//         );
//       },
//     );
//   }
//
//   List<Widget> getButtonList(BuildContext context) {
//     return [
//       Expanded(
//         flex: 3,
//         child: PostButton(
//           text: '다음',
//           onPressed: () async {
//             var data = await _fetchInterestIcons();
//             Provider.of<InterestData>(context).initData(data);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => InterestIconSelectScreen(
//                         interestCategoryId: selectedInterestCategoryId,
//                         interestCategoryNm: selectedInterestCategoryNm,
//                       )),
//             );
// //            Navigator.pushNamed(context, InterestIconSelectScreen.id);
//           },
// //          onPressed: () {
// //            Navigator.push(
// //              context,
// //              MaterialPageRoute(
// //                  builder: (context) => InterestIconSelectScreen(
// //                        interestCategoryId: selectedInterestCategoryId,
// //                        interestCategoryNm: selectedInterestCategoryNm,
// //                      )),
// //            );
// //          },
//         ),
//       ),
//     ];
//   }
//
//   Future _fetchInterestIcons() async {
//     var data = await _nodeConnector.getWithNonAuth(kGetInterestIcons);
//     var meetingIconsData = data[0]["results"];
//     // 토큰 만료 체크 후 필요시 리프레시
//     //await _nodeConnector.refreshIfNeed();
//
//     return meetingIconsData;
//   }
// }
