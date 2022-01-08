import 'package:app/constants/image_constants.dart';

class ProfileIcon {
  int profileIconId;
  String profileNm;
  String profileImgFileNm;
  bool isSelected;

  ProfileIcon(
      {this.profileIconId,
      this.profileNm,
      this.profileImgFileNm,
      this.isSelected = false});

  ProfileIcon.fromJson(Map<String, dynamic> json)
      : profileIconId = json['PROFILE_ICON_ID'],
        profileNm = json['PROFILE_NM'],
        profileImgFileNm = kProfileIconsBasePath + json['PROFILE_IMG_FILE_NM'],
        isSelected = false;

  Map<String, dynamic> toJson() => {
        'profileId': profileIconId,
        'profileNm': profileNm,
        'profileImgFileNm': profileImgFileNm,
        'isSelected': isSelected,
      };

  void toggleSelected() {
    isSelected = !isSelected;
  }
}
