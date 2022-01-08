import 'dart:convert';

import 'package:http/http.dart' as http;

class KakaoApiConnector {
  static final KakaoApiConnector _instance = KakaoApiConnector._internal();

  final kakaoAPI = '34bf88763979aac6ae00f63b4c4d9d60';

  factory KakaoApiConnector() {
    return _instance;
  }

  KakaoApiConnector._internal() {
    //클래스가 최초 생성될때 1회 발생
    //초기화 코드
  }

  Future searchByKeyword(String keyword) async {
    // searching = '합정 스타벅스'
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=$keyword';

    http.Response response =
        await http.get(url, headers: {"Authorization": "KakaoAK $kakaoAPI"});

    // print(response);
    //print('response code $response.statusCode');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print('response : $data');
      // return data['documents'];
      // print(data);
      return data;
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
