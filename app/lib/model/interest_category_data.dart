// import 'dart:collection';
//
// import 'package:app/model/interest_category.dart';
// import 'package:flutter/foundation.dart';
//
// class InterestCategoryData extends ChangeNotifier {
//   List<InterestCategory> _interestCategoryList = [];
//
//   UnmodifiableListView<InterestCategory> get interestCategories {
//     return UnmodifiableListView(_interestCategoryList);
//   }
//
//   int get interestCategoryCount {
//     return _interestCategoryList.length;
//   }
//
//   void initData(var data) {
//     var parsed = data.cast<Map<String, dynamic>>();
//
//     _interestCategoryList = parsed
//         .map<InterestCategory>((json) => InterestCategory.fromJson(json))
//         .toList();
//   }
//
//   void updateSelectedToggle(InterestCategory selectedInterestCategory) {
//     for (InterestCategory interestCategory in _interestCategoryList) {
//       if (selectedInterestCategory.interestCategoryId ==
//           interestCategory.interestCategoryId) {
//         interestCategory.isSelected = true;
//       } else {
//         interestCategory.isSelected = false;
//       }
//     }
//     notifyListeners();
//   }
//
//   void updateMultipleToggle(int i) {
//     _interestCategoryList[i].isSelected = true;
//     notifyListeners();
//   }
// }
