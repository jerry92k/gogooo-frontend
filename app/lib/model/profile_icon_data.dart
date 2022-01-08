// import 'dart:collection';
//
// import 'package:app/model/profile_icon.dart';
// import 'package:flutter/foundation.dart';
//
// class ProfileIconData extends ChangeNotifier {
//   List<ProfileIcon> _profileIconList = [];
//
//   UnmodifiableListView<ProfileIcon> get profileIcons {
//     return UnmodifiableListView(_profileIconList);
//   }
//
//   int get profileIconCount {
//     return _profileIconList.length;
//   }
//
//   void initData(var data) {
//     var parsed = data.cast<Map<String, dynamic>>();
//
//     _profileIconList =
//         parsed.map<ProfileIcon>((json) => ProfileIcon.fromJson(json)).toList();
//   }
//
//   void updateSelectedToggle(ProfileIcon selectedProfileIcon) {
//     for (ProfileIcon profileIcon in _profileIconList) {
//       if (selectedProfileIcon.profileIconId == profileIcon.profileIconId) {
//         profileIcon.isSelected = true;
//         notifyListeners();
//       } else {
//         profileIcon.isSelected = false;
//         notifyListeners();
//       }
//     }
//   }
// }
