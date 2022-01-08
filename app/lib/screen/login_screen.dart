import 'package:app/screen/enroll_profile_step1_screen.dart';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/question_text.dart';
import 'package:app/components/rsa_helper.dart';
import 'package:app/components/tab_controller_component.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/popup_layout.dart';
import 'package:app/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:provider/provider.dart';

//TODO : 각 package 중에서도 안쓰는건 빌드시 미포함하도록 하기

/**[Jerry]
 * 1. class 정의 : 로그인 화면
 * 2. 수행내용
 *  A. 회원가입
 *  B. 로그인
 *    - 로그인 성공시, 다음번 자동로그인을 위해 로그인 계정 저장
 */

class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';
  final String pushToken = '';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  bool _isPasswordVisibility = false;

  //[Jerry] Use shared_preference and KeyStore(KeyChain) For auto-login
  //SharedPreferences _prefs;
  FlutterSecureStorage _storage;
  NodeConnector _nodeConnector;
  String _value;
  String _pushToken;
  bool loginChk = true;
  String _checkMeg = '';

  @override
  void initState() {
    super.initState();
    _storage = FlutterSecureStorage();
    _nodeConnector = NodeConnector();
    //initShPreference();
  }

  // TODO : Improve performance. Issue : rsaKeyHelper.generateKeyPair()
  Future _storeUserData() async {
    RsaKeyHelper rsaKeyHelper = RsaKeyHelper();
    AsymmetricKeyPair keyPair = rsaKeyHelper.generateKeyPair();
    //encrypt password with public key
    String encryptedPW = rsaKeyHelper.encrypt(_password, keyPair.publicKey);

    //store encrypted password in shared_preference
    await PreferenceUtils.setString(kMyEmail, _email);
    await PreferenceUtils.setString(kMyPW, encryptedPW);
    await PreferenceUtils.setString(kMyPushToken, _pushToken);

    // encode PrivateKey to PEM structure
    String encodedPrivateKey =
        rsaKeyHelper.encodePrivateKeyToPem(keyPair.privateKey);

    //store encoded PrivateKey in secure_storage
    await _storage.write(key: kMyKey, value: encodedPrivateKey);
  }

  @override
  Widget build(BuildContext context) {
    double passwordFieldWidth = MediaQuery.of(context).size.width - 90;
    double pwVisibityIconSize = 20.0;

    _pushToken = ModalRoute.of(context).settings.arguments;

    //TODO : 입력 패널이 올라오면 로그인 버튼 가리는 문제있음 =>SingleScrollView 로 변경
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      return Scaffold(
        // resizeToAvoidBottomPadding: false,
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          margin: kBodyMargin,
          //padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 100.0,
                  child: Image.asset(kLoginIcon),
                ),
                Center(
                  child: Text(
                    '공공모임',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 34,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                IconAndText(
                  icon: Icons.mail_outline,
                  title: '이메일',
                ),
                UnderLineTextField(
                    hintText: '회사 이메일을 입력하세요',
                    textInputType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _email = value;
                    },
                    suffixIcon: null),
                SizedBox(
                  height: 8.0,
                ),
                IconAndText(
                  icon: Icons.lock_outline,
                  title: '비밀번호',
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: UnderLineTextField(
                        width: passwordFieldWidth,
                        hintText: '비밀번호를 입력하세요',
                        textInputType: TextInputType.visiblePassword,
                        obscureText: !_isPasswordVisibility,
                        //obscureText: false,
                        onChanged: (value) {
                          _password = value;
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
                loginChk
                    ? Container()
                    : Text(_checkMeg,
                        style: TextStyle(color: Color(0xffff3939))),
                SizedBox(
                  height: 24.0,
                ),
                PostButton(
                  text: '로그인',
                  // TODO. Jerry : Making AutoLogin
                  onPressed: () async {
                    // TODO : Add log-in process

                    doLogin(myUserData);
                    FocusScope.of(context).unfocus();
                  },
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () async {
                        //회원가입 테스트을 위해 적당한 버튼에 이벤트를 달음
                        //testSignUp();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                QuestionText(
                  onTab: () async {
                    Navigator.push(
                      context,
                      PopupLayout(
                        child: SignUpScreen(),
                      ),
                    );
                  },
                  text: '아직 회원이 아니신가요? >',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void doLogin(var myUserData) async {
    var bodyContents = {
      'email': _email,
      'password': _password,
      'pushToken': _pushToken,
    };

    var data = await _nodeConnector.postWithNonAuth(kLogin, bodyContents);

    if (data == null) {
      print('로그인 정보가 올바르지 않습니다.');
      // print(data);
      setState(() {
        loginChk = false;
        _checkMeg = '로그인 정보가 올바르지 않습니다.';
      });
      return;
    } //
    _checkMeg = '';
    loginChk = true;
    // store user data
    var user = data[0]['user'];
    print('user data');
    print(user);
    myUserData.setUserInfo(user);

    var accessToken = data[0]['accessToken']; // String
    var refreshToken = data[0]['refreshToken']; // String
    // store token data
    await PreferenceUtils.setString(kAccessToken, accessToken);
    _storage.write(key: kRefreshToken, value: refreshToken);

    // TODO : 로그인이 오래걸리는데.. 다음 화면으로 넘겨서 백그라운드에서 처리하게 할까?
    // TODO : (자동로그인 체크 필요)

    print(DateTime.now());
    _storeUserData();
    print(DateTime.now());
    if (user['USER_NM'] == null || user['USER_NM'] == '') {
      print('here inside');
      Navigator.pushReplacementNamed(context, EnrollProfileStep1Screen.id);
      return;
    }
    Navigator.pushReplacementNamed(context, TabControllerComponent.id);
  }
}
