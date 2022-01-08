// import 'dart:collection';
//
// import 'package:app/model/interest.dart';
// import 'package:flutter/foundation.dart';
//
// class InterestData extends ChangeNotifier {
//   List<Interest> _interestList = [];
//
//   UnmodifiableListView<Interest> get interests {
//     return UnmodifiableListView(_interestList);
//   }
//
//   int get interestCount {
//     return _interestList.length;
//   }
//
//   void initData(var data) {
//     var parsed = data.cast<Map<String, dynamic>>();
//
//     _interestList =
//         parsed.map<Interest>((json) => Interest.fromJson(json)).toList();
//   }
//
//   void updateSelectedToggle(Interest selectedInterest) {
//     for (Interest interest in _interestList) {
//       if (selectedInterest.interestIconId == interest.interestIconId) {
//         interest.isSelected = true;
//         notifyListeners();
//       } else {
//         interest.isSelected = false;
//         notifyListeners();
//       }
//     }
//   }
// }
