import 'dart:convert';

import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NaverAPIConnector {
  String url = '';

  NaverAPIConnector();

  Future searchLoactions(String idType, String secretType) async {
    // print('url $url');
    http.Response response = await http.get(url, headers: {
      idType: apiKeys[idType],
      secretType: apiKeys[secretType],
    });

    //print('response code $response.statusCode');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print('response : $data');
      return data;
    } else {
      print(response.statusCode);
    }
  }

  void setURL(String url) {
    this.url = url;
  }

  // void setMapURL(String mapX, String mapY){
  //   String apiURL =
  //       'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?crs=NHN:128&w=$width&h=$height&markers=type:d|size:mid|pos:$mapX%20$mapY'; // json 결과
  // }

  final int width = 750;
  final int height = 350;

  Future getLocationIMap(
      String mapX, String mapY, String idType, String secretType) async {
    //[참고] : crs=EPSG:4326   (WGS84 경위도) , NHN:128 (네이버기준)
    String apiURL =
        'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?crs=EPSG:4326&w=$width&h=$height&markers=type:d|size:mid|pos:$mapX%20$mapY'; // json 결과

    try {
      var image = Image.network(apiURL, headers: {
        idType: apiKeys[idType],
        secretType: apiKeys[secretType],
      });
      return image;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
