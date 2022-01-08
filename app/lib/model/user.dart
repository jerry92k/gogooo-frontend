import 'package:app/constants/image_constants.dart';

class User {
  int _id = 0;
  String _name = '';
  String _profileImgPath = '';
  String _starCode = '';
  int _companyId = 0;
  int _gravityVal = 0;
  String _hashtags = '';
  String _sex = '';

  User();
/*  User(int id, String name, String profileImgPath, String starCode,
      int companyId, int gravityVal) {
    _id = id;
    _name = name;
    _profileImgPath = profileImgPath;
    _starCode = starCode;
    _companyId = companyId;
    _gravityVal = gravityVal;
  };*/

  //참: other user인 경우, my user와 company id가 같은 경우만 값을 가져옴. company id가 다른데도 가져오면,클라이언트에서 디버깅으로 해킹가능하므로.

  void setUserInfo(var user) {
    _id = user['USER_ID'];
    _name = user['USER_NM'];
    _profileImgPath = kProfileIconsBasePath + user['PROFILE_IMG_PATH'];
    _starCode = user['STAR_CODE'];
    _companyId = user['COMPANY_ID'];
    _gravityVal = user['GRAVITY_VALUE'];
    _hashtags = user['HASH_TAGS'];
    _sex = user['SEX'];
  }

  User.fromJson(Map<String, dynamic> user)
      : _id = user['USER_ID'],
        _name = user['USER_NM'],
        _profileImgPath = kProfileIconsBasePath + user['PROFILE_IMG_PATH'],
        _starCode = user['STAR_CODE'],
        _companyId = user['COMPANY_ID'],
        _gravityVal = user['GRAVITY_VALUE'],
        _hashtags = user['HASH_TAGS'],
        _sex = user['SEX'];

  int get id => _id;

  String get name => _name;

  String get profileImgPath => _profileImgPath;

  String get starCode => _starCode;

  int get companyId => _companyId;

  int get gravityVal => _gravityVal;

  String get hashtags => _hashtags;

  String get sex => _sex;

  set profileImgPath(String profileImgPath) => _profileImgPath = profileImgPath;
}
