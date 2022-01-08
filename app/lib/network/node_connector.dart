import 'dart:convert';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:http/http.dart' as http;

class NodeConnector {
  static final NodeConnector _instance = NodeConnector._internal();

  factory NodeConnector() {
    return _instance;
  }

  NodeConnector._internal() {
    //클래스가 최초 생성될때 1회 발생
    //초기화 코드
  }

  Future getWithAuth(String path) async {
    try {
      String acceesToken = PreferenceUtils.getString(kAccessToken);
      print(acceesToken);
      if (acceesToken == null || acceesToken == '') {
        print('accessToken이 없습니다');
        return null;
      }
      print(acceesToken);
      var accessTokenDcd = jsonDecode(acceesToken);

      var res = await http.get(
        '$kServerURL$path',
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              accessTokenDcd['token'], // server에 요청 보낼때마다 토큰을 함께 보내야함
        },
      );
      if (res.statusCode != 200) {
        print('response error');
        print(res);
        return null;
      }
      var data = json.decode(res.body);
      print(data);
      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future postWithAuth(String path, var bodyContents) async {
    try {
      String acceesToken = PreferenceUtils.getString(kAccessToken);
      if (acceesToken == null || acceesToken == '') {
        print('accessToken이 없습니다');
        return null;
      }
      var accessTokenDcd = jsonDecode(acceesToken);

      var res = await http.post(
        '$kServerURL$path',
        body: jsonEncode(bodyContents),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              accessTokenDcd['token'], // server에 요청 보낼때마다 토큰을 함께 보내야함
        },
      );

      if (res == null) {
        print('res is empty');
        return null;
      }
      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);
      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future postWithNonAuth(String path, var bodyContents) async {
    try {
      var res = await http.post(
        '$kServerURL$path',
        body: jsonEncode(bodyContents),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);

      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future deleteWithAuth(String path, var bodyContents) async {
    try {
      String acceesToken = PreferenceUtils.getString(kAccessToken);
      if (acceesToken == null || acceesToken == '') {
        print('accessToken이 없습니다');
        return null;
      }
      var accessTokenDcd = jsonDecode(acceesToken);

      var res = await http.delete(
        '$kServerURL$path',
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              accessTokenDcd['token'], // server에 요청 보낼때마다 토큰을 함께 보내야함
        },
      );

      if (res == null) {
        print('res is empty');
        return null;
      }
      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);
      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future deleteWithNonAuth(String path, var bodyContents) async {
    try {
      var res = await http.delete(
        '$kServerURL$path',
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);

      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

/*
  Future postLogin(String path, var bodyContents,var accessToken) async {
    try {
      var data = await postWithNonAuth(path, bodyContents);

      if (data != null) {
        storeTokens(data);
        return data;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }
*/
/*
  Future postSignUp(String path, var bodyContents) async {
    var data = postWithNonAuth(path, bodyContents);

    return data;
  }
*/
  Future getWithNonAuth(String path) async {
    try {
      var res = await http.get(
        '$kServerURL$path',
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);
      print('return data');
      // print(data);
      // var refreshToken = data[0]["refreshToken"];
//
      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future refreshIfNeed(String refreshToken, var accessTokenDcd) async {
    try {
      var res = await http.post(
        '$kServerURL$kRefresh',
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              accessTokenDcd['token'], // server에 요청 보낼때마다 토큰을 함께 보내야함
        },
      );

      if (res.statusCode != 200) {
        print('error');
        return null;
      }
      var data = json.decode(res.body);

      return data;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
