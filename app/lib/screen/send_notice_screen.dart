import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/question_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SendNoticeScreen extends StatelessWidget {
  static String id = '/send_notice_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: kBodyMargin,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80.0,
            ),
            Container(
              child: Text(
                '브로든에게\n메일을 보내주세요.',
                style: kSignUpTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                ),
                child: Text(
                  kBroadenMailAddress,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 30.0,
            ),
            buildRichText(),
          ],
        ),
      ),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '확인',
          onPressed: () {
            //TODO: 로그인 화면으로 돌아가게 변경
            Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id));
            //Navigator.of(context).pop();
          },
        ),
      ),
    ];
  }

  RichText buildRichText() {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: '- 회원가입시 입력한 ',
            style: kNotiContentTextStyle,
          ),
          TextSpan(
            text: '본인의 회사 이메일에서 ',
            style: kNotiRedContentTextStyle,
          ),
          TextSpan(
            text: '브로든으로\n  메일을 보내주세요.\n\n',
            style: kNotiContentTextStyle,
          ),
          TextSpan(
            text: '- ',
            style: kNotiContentTextStyle,
          ),
          TextSpan(
            text: '메일 본문',
            style: kNotiRedContentTextStyle,
          ),
          TextSpan(
            text: '에는 ',
            style: kNotiContentTextStyle,
          ),
          TextSpan(
            text: '수신 가능한 개인 이메일을 기입',
            style: kNotiRedContentTextStyle,
          ),
          TextSpan(
            text: '해주세요.\n  (예:gamil,naver 등)\n\n',
            style: kNotiContentTextStyle,
          ),
          TextSpan(
            text: '- 알려주신 개인 이메일로 비밀번호를 초기화할 수 있는\n  링크를 보내드립니다.',
            style: kNotiContentTextStyle,
          ),
        ],
      ),
    );
  }
}
