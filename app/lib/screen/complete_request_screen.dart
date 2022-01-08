import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/question_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/screen/login_screen.dart';
import 'package:app/screen/send_notice_screen.dart';
import 'package:app/utils/method_utils.dart';
import 'package:flutter/material.dart';

class CompleteRequestScreen extends StatelessWidget {
  static String id = '/complete_request_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: kBodyMargin,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  '회사 이메일을 확인하세요',
                  style: kSignUpTitleStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '가입 인증 메일 링크를 클릭 후\n비밀번호를 설정해주시면 가입 신청이 완료됩니다.',
                  style: kSignUpBodyStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Image.asset(kCompleteSignUpImage),
                SizedBox(
                  height: 100.0,
                ),
                QuestionText(
                  onTab: () async {
                    //  Navigator.of(context).push(_createRoute());
                    Navigator.of(context)
                        .pushReplacementNamed(SendNoticeScreen.id);
                  },
                  text: '인증 메일이 오지 않았나요? >',
                )
              ],
            ),
          ),
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
}
