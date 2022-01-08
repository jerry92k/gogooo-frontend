import 'package:app/constants/routes_constants.dart';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:app/components/rsa_helper.dart';
import 'package:app/constants/constants.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:provider/provider.dart';

/**[Jerry]
 * 1. Class 정의 : 로딩 화면
 * 2. 수행내용 : 자동로그인 가능 유무 확인 (SharedPreferences에 로그인 계정이 저장되어 있으면 자동로그인)
 *   A. (저장된 계정이 있는 경우) 서버에 자동으로 로그인 요청을 보낸후, 초기 데이터 읽어오기
 *   B. (저장된 계정이 없을 경우) LoginScreen 화면으로 이
 */
class LoadScreen extends StatefulWidget {
  static String id = '/load_screen';

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final FirebaseMessaging fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    //TODO : 로그인시 push data 못가져온거 있으면 가져오가
  }

  //TODO : [Jerry] 로딩화면 비쥬얼라이징
  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      return FutureBuilder(
          future: _loadUserData(myUserData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (snapshot.hasData == false) {
              return Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('loading'),
                ],
              );
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            }

            return Container(
              child: Center(
                  child: FlatButton(
                child: Text('login'),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              )),
            );
          });
    });
  }

  Future _loadUserData(var myUserData) async {
    NodeConnector _nodeConnector = NodeConnector();
    FlutterSecureStorage _storage = FlutterSecureStorage();

    String email;
    String password;

    email = PreferenceUtils.getString(kMyEmail);

    String pushToken = PreferenceUtils.getString(kMyPushToken);

    print('pushToken');
    print(pushToken);

    if (pushToken == '') {
      pushToken = await fcm.getToken();
      print(pushToken);
    }
    // 기존 로그인 계정이 있으면, 자동으로 서버에 로그인 요청
    if (email != '') {
      // SharedPreferences에서 저장된 패스워드(암호화된)를 읽어옴
      String encryptedPW = PreferenceUtils.getString(kMyPW);

      // SecureStorage에서 private key를 읽어옴 (패스워드 암호화시에 사용한 public key와 pair)
      var encodedPEM = await _storage.read(key: kMyKey);

      RsaKeyHelper rsaKeyHelper = RsaKeyHelper();

      // PEM 형태로 저장한 privateKey를 parsing하여 사용가능한 key형태로 변환
      RSAPrivateKey rsaPrivateKey =
          rsaKeyHelper.parsePrivateKeyFromPem(encodedPEM);

      password = rsaKeyHelper.decrypt(encryptedPW, rsaPrivateKey);

      var bodyContents = {
        'email': email,
        'password': password,
        'pushToken': pushToken,
      };
      var data = await _nodeConnector.postWithNonAuth(kLogin, bodyContents);

      if (data != null) {
        // store user data
        var user = data[0]['user'];

        myUserData.setUserInfo(user);

        // store token data
        var accessToken = data[0]['accessToken'];
        var refreshToken = data[0]['refreshToken'];

        await PreferenceUtils.setString(kAccessToken, accessToken);
        _storage.write(key: kRefreshToken, value: refreshToken);

        //TODO: 테스트를 위해 주석처리해놓음. 추후 주석해제
        /* if (isVerified) {
        Navigator.pushReplacementNamed(context, TabControllerComponent.id);
        return;
      }*/
      }
    }
    print('here test');
    print(pushToken);
    // 저장된 계정이 없는 경우, 로그인 페이지로 이동
    //TODO : 생성한 pushToken 넘겨줘야함
    Navigator.pushReplacementNamed(
      context,
      LoginScreen.id,
      arguments: pushToken,
    );
  }
}
