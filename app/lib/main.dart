import 'dart:convert';
import 'dart:io';
import 'package:app/arguments/ChatArgument.dart';
import 'package:app/components/search_location.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/model/my_user.dart';
import 'package:app/screen/account_management_screen.dart';
import 'package:app/screen/password_change_screen.dart';
import 'package:app/screen/send_notice_screen.dart';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:app/components/tab_controller_component.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/txt_style_constants.dart';

import 'package:app/db/sqlite_helper.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/screen/chat_screen.dart';
import 'package:app/screen/complete_request_screen.dart';
import 'package:app/screen/enroll_profile_step1_screen.dart';
import 'package:app/screen/enroll_profile_step2_screen.dart';
import 'package:app/screen/enroll_profile_step3_screen.dart';
import 'package:app/screen/feed_screen.dart';
import 'package:app/screen/load_screen.dart';
import 'package:app/screen/login_screen.dart';
import 'package:app/screen/interest_category_select_screen.dart';
import 'package:app/screen/interest_icon_select_screen.dart';
import 'package:app/screen/meeting_detail_screen.dart';
import 'package:app/screen/meeting_plan_screen.dart';
import 'package:app/screen/meeting_screen.dart';
import 'package:app/screen/my_space_screen.dart';
import 'package:app/screen/password_change_screen.dart';
import 'package:app/screen/settings_screen.dart';
import 'package:app/screen/notice_screen.dart';
import 'package:app/screen/notice_detail_screen.dart';
import 'package:app/screen/star_profile.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//TODO : ??????????????? UI ??????
//TODO : ????????? ???????????? ?????? ????????? ?????????
//TODO : IOS ?????? ?????? ??????

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initFlutterNotiPlugin();
  await Firebase.initializeApp();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(
    Gomeeting(),
  );
}

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification notification = message.notification;
  print('onbackground: $message');
  print('onbackground: ${message.data['chatMsg']}');
  //await _deleteNotificationChannel();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      kChatChannelId, kChatChannelName, kChatChanneldescription,
      groupKey: kChannelGroupId, icon: '@mipmap/ic_launcher');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  if (flutterLocalNotificationsPlugin == null) {
    print('plugin is null');
  }
  await flutterLocalNotificationsPlugin.show(
      0, '????????? ????????? ????????? ??????', message.data['chatMsg'], platformChannelSpecifics,
      payload: message.data['meetingId']);

  return 'onbackground';
}

class Gomeeting extends StatefulWidget {
  @override
  _GomeetingState createState() => _GomeetingState();
}

class _GomeetingState extends State<Gomeeting> {
  SqliteHelper _db = SqliteHelper();
  GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  Future<void> initFlutterNotiPlugin() async {
    var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSetting = IOSInitializationSettings(
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    bool isInit = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectedNotification);

    if (!isInit) {
      print('init not work');
      return;
    }
    print('init plugin');
  }

  Future onSelectedNotification(String payload) async {
    print('this is onselectedNotification event');
    print(payload);

    if (payload == null || payload == '') {
      print('payload is empty');
      return;
    }
    int meetingId = int.parse(payload);
    navigatorKey.currentState
        .pushNamed('/chat_screen', arguments: ChatArgument(meetingId, []));
    // selectNotificationSubject.add(payload);
  }

  // TODO : background?????? ????????? ????????? ?????????? ???????????? ?????? ???????????????
  // refresh ????????? ????????? access token??? ???????????? ?????? ????????? ??????????????? ?????????
  // ?????? ?????????????????? ????????? isolate ???????????? accesstoken??? ???????????????!

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            //TODO : ????????? ????????? ?????? 3???????????? ????????????
            minimumFetchInterval: 15,
            // 180??? = 3??????
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      await tokenRefreshTask();

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      /*    setState(() {
        _status = status;
      });*/
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    BackgroundFetch.start().then((int status) {
      print('[BackgroundFetch] start success: $status');
      //tokenRefreshTask();
    }).catchError((e) {
      print('[BackgroundFetch] start FAILURE: $e');
    });
  }

  bool verifyRequireFresh(var accessTokenDcd) {
    var expireTime = accessTokenDcd['exp'];

    int currentTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    if (expireTime - currentTime <= 1800) {
      // ??????????????? 30??? ????????? ????????????(???????????? ??????)
      return true;
    }
    return false;
  }

  Future tokenRefreshTask() async {
    print('fetch task');
    if (PreferenceUtils.getObject() == null) return;
    String aceesToken = PreferenceUtils.getString(kAccessToken);

    if (aceesToken != null) {
      var accessTokenDcd = jsonDecode(aceesToken);
      bool isRequireRefr = verifyRequireFresh(accessTokenDcd);
      if (isRequireRefr) {
        FlutterSecureStorage _storage = FlutterSecureStorage();
        var refreshTokenSt = await _storage.read(key: kRefreshToken);

        NodeConnector nodeConnector = NodeConnector();
        var data =
            await nodeConnector.refreshIfNeed(refreshTokenSt, accessTokenDcd);
        if (data != null) {
          var newAccessToken = data[0]['accessToken'];
          await PreferenceUtils.setString(kAccessToken, newAccessToken);

          String newRefreshToken = data[0]['refreshToken'];
          if (newRefreshToken != '') {
            _storage.write(key: kRefreshToken, value: newRefreshToken);
          }
        }
      } else {
        print('token exp time enough');
      }
    } else {
      print('accessToken is null');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko');
    Intl.defaultLocale = "ko";
    print('here init app');
  }

  void initPreference() async {
    await PreferenceUtils.init();
  }

  void initDatabase() async {
    await _db.initDatabase();
    //await _db.deleteData(kdeleteChatAll());
    await _db.createChatTable();
  }

  void initFireBaseMessaging() async {
    //await initChannel();

    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    print('initialMessage.data');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('event : omMessageOpendApp');
      print(message);
      print(message.data['type']);
      if (message.data['type'] == 'chat') {
        int meetingId = int.parse(message.data['meetingId']);
        navigatorKey.currentState
            .pushNamed('/chat_screen', arguments: ChatArgument(meetingId, []));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('here event: onMessage');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
    });
  }

  Future _initSetting(context) async {
    await initFlutterNotiPlugin();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await initDatabase();

    await initPlatformState();

    await initPreference();

    await initFireBaseMessaging();

    var userdata = await _getUserData();

    return userdata;
  }

  Future _getUserData() async {
    NodeConnector _nodeConnector;
    _nodeConnector = NodeConnector();
    var data = await _nodeConnector.getWithAuth(kUserData);

    print(data);
    if (data == null) {
      return 'noData';
    }
    // store user data
    return data[0]['user'];
  }

//
//

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initSetting(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //?????? ????????? data??? ?????? ?????? ?????? ???????????? ???????????? ????????? ????????????.
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          }
          //error??? ???????????? ??? ?????? ???????????? ?????? ??????
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }
          var userdata = snapshot.data;

          bool passLogin = true;
          if (userdata == 'noData') {
            print('no data here');
            passLogin = false;
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MyUserData(userdata)),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: ThemeData(
                // Define the default brightness and colors.
                brightness: Brightness.light,
                primaryColor: Colors.white,
                accentColor: Colors.white,
                scaffoldBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                // Define the default font family.
                fontFamily: kBasicFontFamily,

                appBarTheme: AppBarTheme(
                    elevation: 0.0,
                    color: Colors.white,
                    textTheme: TextTheme(title: kAppbarPlainTitleTextStyle)),

                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: TextTheme(
                  body1: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                  ),
                  body2: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              initialRoute: EnrollProfileStep1Screen.id,

              //TODO: ?????? ???????????? ???????????? : ???????????? ?????????
              // TODO: ???????????? ?????? ???????????? ??????
              //passLogin ? TabControllerComponent.id : LoadScreen.id,

              // TEST: ?????????????????? ?????? ?????? ??????, LoginScreen ??? ????????? LoadScreen ?????? ??????????????? ???
              //  ChatScreen.id,
              routes: {
                SearchLoaction.id: (context) => SearchLoaction(),
                LoadScreen.id: (context) => LoadScreen(),
                LoginScreen.id: (context) => LoginScreen(),
                TabControllerComponent.id: (context) =>
                    TabControllerComponent(),
                // ?????????
                MeetingScreen.id: (context) => MeetingScreen(),
                // ????????? - ???????????????
                MeetingPlanScreen.id: (context) => MeetingPlanScreen(),
                ChatScreen.id: (context) => ChatScreen(),
                // ????????? - ??????????????? - ???????????? ??????
                InterestCategorySelectScreen.id: (context) =>
                    InterestCategorySelectScreen(),
                // ????????? - ??????????????? - ????????? ??????
                InterestIconSelectScreen.id: (context) =>
                    InterestIconSelectScreen(),
                // ????????? - ??????????????????
                MeetingDetailScreen.id: (context) => MeetingDetailScreen(
                    //meetingItem: null,
                    ),
                // ?????????
                FeedScreen.id: (context) => FeedScreen(),
                // ????????????
                MySpaceScreen.id: (context) => MySpaceScreen(),
                // ?????????
                SettingsScreen.id: (context) => SettingsScreen(),
                // ?????????- ????????????
                NoticeScreen.id: (context) => NoticeScreen(),
                // ?????????- ???????????? - ???????????? ????????????
                NoticeDetailScreen.id: (context) => NoticeDetailScreen(
                      noticeData: null,
                    ),
                // ?????????- ????????????
                AccountManagementScreen.id: (context) =>
                    AccountManagementScreen(),
                // ?????????- ???????????? - ???????????? ??????
                PasswordChangeScreen.id: (context) => PasswordChangeScreen(),

                // ????????????
                EnrollProfileStep1Screen.id: (context) =>
                    EnrollProfileStep1Screen(),
                EnrollProfileStep2Screen.id: (context) =>
                    EnrollProfileStep2Screen(),
                EnrollProfileStep3Screen.id: (context) =>
                    EnrollProfileStep3Screen(),
                StarProfileScreen.id: (context) => StarProfileScreen(),
                CompleteRequestScreen.id: (context) => CompleteRequestScreen(),
                SendNoticeScreen.id: (context) => SendNoticeScreen(),
              },
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // selectNotificationSubject.close();
    super.dispose();
  }
}
