import 'package:app/components/fixed_bottom.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/constants/constants.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/screen/account_management_screen.dart';
import 'package:provider/provider.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:flutter/material.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/components/alert_button.dart';

class PasswordChangeScreen extends StatefulWidget {
  static String id = '/password_change_screen';

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  MyUser myUser;
//  String password;
  bool isInit = true;
  NodeConnector _nodeConnector;

  String _currentPassword; // 현재 비밀번호
  String _newPassword; // 새로운 비밀번호
  String _newPasswordRepeat; // 새로운 비밀번호 다시입력
  bool _isEqualsPassword = true;
  bool _isPasswordVisibility = false;
  bool _isSuccessed = false;

  @override
  void initState() {
    super.initState();
    _nodeConnector = NodeConnector();
  }

  @override
  Widget build(BuildContext context) {
    double passwordFieldWidth = MediaQuery.of(context).size.width - 90;
    double pwVisibityIconSize = 20.0;

    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0.0,
          title: Text(
            '비밀번호 변경',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: BackButtonLeadingAppbar(),
          centerTitle: true,
        ),
        body: Container(
          margin: kBodyMargin,
          child: ListView(
            children: <Widget>[
              IconAndText(
                icon: Icons.lock_outline,
                title: '현재 비밀번호',
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: UnderLineTextField(
                      width: passwordFieldWidth,
                      hintText: '현재 비밀번호를 입력하세요',
                      textInputType: TextInputType.visiblePassword,
                      obscureText: !_isPasswordVisibility,
                      onChanged: (value) {
                        _currentPassword = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPasswordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xffb7b7b7),
                      size: pwVisibityIconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisibility
                            ? _isPasswordVisibility = false
                            : _isPasswordVisibility = true;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              // 새로운 비밀번호
              IconAndText(
                icon: Icons.lock_outline,
                title: '새로운 비밀번호',
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: UnderLineTextField(
                      width: passwordFieldWidth,
                      hintText: '새로운 비밀번호를 입력하세요',
                      textInputType: TextInputType.visiblePassword,
                      obscureText: !_isPasswordVisibility,
                      onChanged: (value) {
                        _newPassword = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPasswordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xffb7b7b7),
                      size: pwVisibityIconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisibility
                            ? _isPasswordVisibility = false
                            : _isPasswordVisibility = true;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: UnderLineTextField(
                      width: passwordFieldWidth,
                      hintText: '비밀번호를 다시 입력하세요',
                      textInputType: TextInputType.visiblePassword,
                      obscureText: !_isPasswordVisibility,
                      onChanged: (value) {
                        setState(() {
                          _newPasswordRepeat = value;

                          // 새로운 비밀번호 다시입력한 값이 일치하는지 확인
                          if (_newPassword != _newPasswordRepeat) {
                            _isEqualsPassword = false;
                          } else {
                            _isEqualsPassword = true;
                          }
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPasswordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xffb7b7b7),
                      size: pwVisibityIconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisibility
                            ? _isPasswordVisibility = false
                            : _isPasswordVisibility = true;
                      });
                    },
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  _isEqualsPassword ? '' : '비밀번호가 서로 다릅니다.',
                  style: TextStyle(
                    color: Color(_isEqualsPassword
                        ? 0xff4545f1
                        : _isEqualsPassword
                            ? 0xff4545f1
                            : 0xffff3939),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: FixedBottom(getButtonList(context)),
      );
    });
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '확인',
          onPressed: () {
            // DB 처리
            updatePassword();
          },
        ),
      ),
    ];
  }

  Future updatePassword() async {
    if (_newPassword != _newPasswordRepeat) {
      print('새로운 비밀번호가 서로 다릅니다');

      setState(() {
        _isSuccessed = false;
      });

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildAlertDialog(context, '비밀번호 확인', '새로운 비밀번호가 서로 다릅니다');
        },
      );
    } else {
      // 새로운 비밀번호가 유효한 경우
      var bodyContents = {
        "USER_ID": myUser.id,
        'CURRENT_PASSWORD': _currentPassword,
        'NEW_PASSWORD': _newPassword,
        'NEW_PASSWORD_REPEAT': _newPasswordRepeat,
      };

      // 사용자 비밀번호 수정
      var data = await _nodeConnector.postWithNonAuth(
          kUpdateUserPassword, bodyContents);

      print(data);

      if (data == null) {
        setState(() {
          _isSuccessed = false;
        });

        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return buildAlertDialog(context, '비밀번호 변경 실패', '');
          },
        );
      } else {
        if (data[0]['results'].length > 0) {
          setState(() {
            _isSuccessed = true;
          });
        }

        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return buildAlertDialog(context, '비밀번호 변경 결과', data[0]['message']);
          },
        );
      }
    }
  }

  AlertDialog buildAlertDialog(
      BuildContext context, String titleText, String bodyText) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        titleText,
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
                bodyText,
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
            ),
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
                    print('_isSuccessed = ${this._isSuccessed}');

                    if (_isSuccessed) {
                      Navigator.popUntil(context,
                          ModalRoute.withName(AccountManagementScreen.id));
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => AccountManagementScreen()),
//                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
