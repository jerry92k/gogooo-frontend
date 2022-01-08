import 'package:app/model/user.dart';

class MyUser extends User {
  String _email = '';
  String _signUpDttm = null; // datetime
  String _lastLoginDttm = null; // datetime
  String _withdrawalDttm = null; // datetime

  void setUserInfo(var user) {
    super.setUserInfo(user);

    _email = user['EMAIL'];
    _signUpDttm = user['SIGN_UP_DTTM'];
    _lastLoginDttm = user['LAST_LOGIN_DTTM'];
    _withdrawalDttm = user['WITHDRAWAL_DTTM'];
  }

  void updateProfileIcon(String profileImgPath) {
    super.profileImgPath = profileImgPath;
  }

  String get email => _email;

  String get signUpDttm => _signUpDttm;

  String get lastLoginDttm => _lastLoginDttm;

  String get withdrawalDttm => _withdrawalDttm;
}
