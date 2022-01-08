import 'package:app/components/tab_controller_component.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/screen/load_screen.dart';
import 'package:app/screen/login_screen.dart';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:flutter/material.dart';
import 'package:app/components/alert_button.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/setting_data.dart';
import 'package:app/screen/notice_screen.dart';
import 'package:app/screen/account_management_screen.dart';
import 'package:app/screen/password_change_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';

class SettingTile extends StatefulWidget {
  SettingData settingData;
  SettingTile({this.settingData});

  @override
  _SettingTileState createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  MyUser myUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      bool hasLeading = false;
      if ((widget.settingData.settingImgFileNm
              .replaceAll(kSettingIconsBasePath, ''))
          .isNotEmpty) {
        hasLeading = true;
      }

      return ListTile(
        leading: hasLeading
            ? Image.asset(widget.settingData.settingImgFileNm)
            : null,
        title: Text(widget.settingData.settingNm),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () async {
          if (widget.settingData.settingNm == '공지사항') {
            print('설정 > 공지사항');
            Navigator.pushNamed(context, NoticeScreen.id);
          } else if (widget.settingData.settingNm == '계정관리') {
            print('설정 > 계정관리');
            Navigator.pushNamed(context, AccountManagementScreen.id);
          } else if (widget.settingData.settingNm == '비밀번호 변경') {
            print('설정 > 계정관리 > 비밀번호 변경');
            Navigator.pushNamed(context, PasswordChangeScreen.id);
          } else if (widget.settingData.settingNm == '로그아웃') {
            print('설정 > 계정관리 > 로그아웃');
            //myUser = MyUser();
            //doLogout()

            // 1) refresh token 만료
            FlutterSecureStorage _storage;
            _storage = FlutterSecureStorage();
            await _storage.delete(key: kRefreshToken);

            //2) access token 만료
            await PreferenceUtils.deleteKey(kAccessToken);

            // 3) email, password 저장정보 삭제, fcm 토큰 삭제
            await PreferenceUtils.deleteKey(kMyEmail);
            await PreferenceUtils.deleteKey(kMyPW);
            await PreferenceUtils.deleteKey(kMyPushToken);

            myUserData.initMyUser();
            Navigator.popUntil(
                context, ModalRoute.withName(TabControllerComponent.id));
            Navigator.popAndPushNamed(context, LoadScreen.id);
          } else {
            print('새로운 기능 사용을 위해 업데이트 해주세요.');
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return buildAlertDialog(context);
              },
            );
          }
        },
      );
    });
  }

  Future doLogout() {}

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        '최신 버전으로 업데이트',
        style: kAlertTitleTextStyle,
      ),
      content: Container(
//        height: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width / 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                '새로운 기능 사용을 위해 업데이트 해주세요',
                style: kAlertBodyTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Container(
                decoration: kUpperLineBoxDecoration,
                child: buildAlertButtons(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildAlertButtons(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Color(0xff4545f1),
                child: AlertButton(
                    text: '확인',
                    isCancel: false,
                    onTab: () {
                      Navigator.of(context).pop();
                    })),
          ),
        ],
      ),
    );
  }
}
