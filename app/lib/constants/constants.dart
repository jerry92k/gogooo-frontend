import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String kMyEmail = 'myEmail';
const String kMyKey = 'myKey';
const String kMyPW = 'myPW';
const String kMyPushToken = 'myPushToken';
const String kAccessToken = 'accessToken';
const String kRefreshToken = 'refreshToken';
const String kUserId = 'userId';

// 모임개설
const int kMeetingPlanMonth = 3; // 현재 기준 3개월 이후까지 개설 가능
const String kHintTextDate = "모임 일시를 입력하세요";
const String kHintTextLocation = "장소를 입력하세요";
const String kHhintTextNumOfPeople = "인원을 입력하세요";
const String kHhintTextPrice = "회비를 입력하세요";
const String kHhintTextComment = "#태그, 내용을 자유롭게 입력하세요";
const String kHintTextLoc = "장소를 입력하세요";
//TODO : production 환경에서는 실제서버 url로 변경
final String kServerURL =
    Platform.isAndroid ? 'http://10.0.2.2:8001' : 'http://localhost:8001';

final String kNaverSearchClientIdKeyword = 'X-Naver-Client-Id';
final String kNaverSearchClientSecretKeyword = 'X-Naver-Client-Secret';

final String kNaverMapClientIdKeyword = 'X-NCP-APIGW-API-KEY-ID';
final String kNaverMapClientSecretKeyword = 'X-NCP-APIGW-API-KEY';

final Map<String, String> apiKeys = {
  kNaverSearchClientIdKeyword: 'qn2RBy94RxUpcTHX8VVv',
  kNaverSearchClientSecretKeyword: '7ktu9Us_Ys',
  kNaverMapClientIdKeyword: '81dopzu0fh',
  kNaverMapClientSecretKeyword: 'kp5GzpIJtASiKMaewKMjBDHZYUI9LjCWvw9KQKrS',
};

//socket.io config
final String kChatSocket = '${kServerURL}/chat';

const kInputTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Color(0xffb7b7b7)),
  //contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
  contentPadding: EdgeInsets.only(bottom: 2.0, left: 10.0),
  border: kUnderlineInputBorder,
  enabledBorder: kUnderlineInputBorder,
  focusedBorder: kUnderlineInputBorder,
);

const kPostButtonMargin = EdgeInsets.only(left: 20.0, right: 20.0);

const kBodyMargin = EdgeInsets.all(20.0);

const kUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xffb7b7b7),
    width: 0.5,
  ),
  borderRadius: BorderRadius.all(Radius.circular(2.0)),
);

const kUpperLineBoxDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
      color: Color(0xffdddddd),
    ),
  ),
);

const kBottomButtonSize = 55.0;
const kSystemName = 'system';

const kPostMeet = '예정모임';
const kPreMeet = '지난모임';
const kInstMeet = '관심모임';
const kMadeMeet = '만든모임';

final kSnackbarColor = Colors.blueAccent.withOpacity(0.8);

const String kChatChannelId = 'broadenwaychannelChat';
const String kChatChannelName = 'broadenwayChat';
const String kChatChanneldescription = 'broadenway chat notification';

const String kChannelGroupId = 'boradenChannel';
const String kChannelGroupName = 'boradenChannelGroup';
const String kChannelGroupDescription = 'this is broaden noti channel';
const String kBroadenMailAddress = 'broadenway@gmail.com';
