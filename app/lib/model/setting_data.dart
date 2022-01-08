import 'package:app/constants/image_constants.dart';

class SettingData {
  String settingNm;
  String settingImgFileNm;
  String status;

  SettingData(this.settingNm, this.settingImgFileNm, this.status);

  SettingData.fromJson(Map<String, dynamic> json)
      : settingNm = json['SETTING_NM'],
        settingImgFileNm = kSettingIconsBasePath + json['SETTING_IMG_FILE_NM'];

  Map<String, dynamic> toJson() => {
        'settingNm': settingNm,
        'settingImgFileNm': settingImgFileNm,
      };
}
