import 'package:app/constants/routes_constants.dart';
import 'package:app/model/my_user.dart';
import 'package:app/network/node_connector.dart';
import 'package:flutter/foundation.dart';

class MyUserData extends ChangeNotifier {
  MyUser _myUser;

  MyUserData(var userdata) {
    _myUser = MyUser();
    if (userdata != 'noData') {
      setUserInfo(userdata);
    }
  }

  void initMyUser() {
    _myUser = MyUser();
  }

  // 프로필 아이콘 바꿀때 사용
  void updateProfileIcon(String profileImgPath) {
    _myUser.updateProfileIcon(profileImgPath);
    notifyListeners();
  }

  void setUserInfo(var user) {
    _myUser.setUserInfo(user);
  }

  Future<MyUser> getMyUser() async {
    if (_myUser == null || _myUser.id == 0) {
      NodeConnector _nodeConnector;
      _nodeConnector = NodeConnector();
      var data = await _nodeConnector.getWithAuth(kUserData);

      if (data == null) {
        print('로그인 정보가 올바르지 않습니다.');
        return null;
      }
      // store user data
      var userdata = data[0]['user'];

      setUserInfo(userdata);
    }
    return _myUser;
  }

  MyUser get myUser {
    return _myUser;
  }
}
