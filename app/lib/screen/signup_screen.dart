import 'dart:convert';

import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/alert_button.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/popup_appbar.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/complete_request_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  static String id = '/sign_up_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  NodeConnector _nodeConnector;
  String _email = '';
  String _isUniqueID = '';

  @override
  void initState() {
    super.initState();
    _nodeConnector = NodeConnector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PopupAppBar(
        title: '',
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: kBodyMargin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                '가입신청',
                style: kSignUpTitleStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                '서로 간의 신뢰 보장을 위해\n가입 시 회사 이메일 인증이 필요합니다.',
                style: kSignUpBodyStyle,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            IconAndText(
              icon: Icons.mail_outline,
              title: '이메일',
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: UnderLineTextField(
                    hintText: '회사 이메일을 입력하세요',
                    onChanged: (value) {
                      setState(() {
                        _isUniqueID = '';
                        _email = value;
                      });
                    },
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //width: kNickNameValidateSize,
                    child: OutlineButton(
                      onPressed: () {
                        checkDup();
                        FocusScope.of(context).unfocus();
                      },
                      child: Text("중복확인"),
                      borderSide: BorderSide(color: Color(0xffb7b7b7)),
                      //shape: StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  _isUniqueID == ''
                      ? ''
                      : _isUniqueID == 'true'
                          ? '사용가능한 이메일 입니다.'
                          : '이미 사용중인 이메일 입니다.',
                  style: TextStyle(
                    color: Color(_isUniqueID == ''
                        ? 0xff4545f1
                        : _isUniqueID == 'true'
                            ? 0xff4545f1
                            : 0xffff3939),
                  ),
                ),
              ),
            ),
            Expanded(
              //flex: 5,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: buildRichText(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FixedBottom(
        getButtonList(),
      ),
    );
  }

  Future checkDup() async {
    var bodyContents = {
      'email': _email,
    };

    var data =
        await _nodeConnector.postWithNonAuth(kcheckDupEmail, bodyContents);
    print(data);

    setState(() {
      _isUniqueID = data['isUnique'];
    });
  }

  //TODO : 가입신청 화면에 password 필드를 넣으면 'password' 인자를 변수로 변경
  Future applySignUp(BuildContext context) async {
    var bodyContents = {
      'email': _email,
    };

    var data = await _nodeConnector.postWithNonAuth(kSignUp, bodyContents);
    if (data == null) {
      //오류
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return getAlertMessage(context, '이메일 발송 오류', '이메일 발송중 오류가 발생하였습니다.');
        },
      );
      return;
    }
    Navigator.pushReplacementNamed(context, CompleteRequestScreen.id);
  }

  List<Widget> getButtonList() {
    return [
      Expanded(
        flex: 3,
        child: new Builder(builder: (BuildContext snackContext) {
          return PostButton(
            text: '가입신청',
            onPressed: () {
              if (_isUniqueID != 'true') {
                //      return new FloatingActionButton(onPressed: () {
                Scaffold.of(snackContext)
                    .showSnackBar(getSnackBar('유효한 이메일을 입력해주세요.'));
                //TODO: snackbar 디자인 => 다른 곳도 디자인
                return;
              }

              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return buildAlertDialog(context);
                },
              );
            },
          );
        }),
      ),
    ];
  }

  RichText buildRichText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '이메일 인증 시 ',
            style: kLightTextStyle,
          ),
          TextSpan(
            text: '개인정보제공 ',
            style: kLightHyperLinkedTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //Navigator
                print('here is hyperlink');
              },
          ),
          TextSpan(
            text: '및 ',
            style: kLightTextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: '서비스 이용약관',
            style: kLightHyperLinkedTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //Navigator
                print('here is hyperlink');
              },
          ),
          TextSpan(
            text: '에\n동의한 것으로 간주합니다.',
            style: kLightTextStyle,
          ),
        ],
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        '회사 이메일 인증',
        style: kAlertTitleTextStyle,
      ),
      content: Container(
        height: MediaQuery.of(context).size.width / 2.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Text(
                '입력하신 회사 이메일로 가입 인증을\n위한 메일을 보내드립니다. 이메일 주소를\n한번 더 확인해주세요.',
                style: kAlertBodyTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                // TODO : 이메일 변수로 변경
                _email,
                style:
                    kAlertBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
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
            flex: 3,
            child: Container(
              child: AlertButton(
                text: '취소',
                isCancel: true,
                onTab: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
                color: Color(0xff4545f1),
                child: AlertButton(
                  text: '이메일 발송',
                  isCancel: false,
                  onTab: () async {
                    applySignUp(context);
                  },
                )),
          ),
        ],
      ),
    );
  }
}
