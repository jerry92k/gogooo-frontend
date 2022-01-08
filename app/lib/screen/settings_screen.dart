import 'package:app/constants/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:app/components/setting_tile.dart';
import 'package:app/model/setting_data.dart';
import 'package:provider/provider.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/network/node_connector.dart';

class SettingsScreen extends StatefulWidget {
  static String id = '/setting_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MyUser myUser;
  bool isInit = true;
  List<SettingData> settingDataList;
  NodeConnector _nodeConnector;

  @override
  void initState() {
    super.initState();

    _nodeConnector = NodeConnector();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          // back bottn 삭제
          title: Text(
            '설정',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _fetchSettingsList(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (isInit) {
                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
                var data = snapshot.data;

                settingDataList = data
                    .map<SettingData>((json) => SettingData.fromJson(json))
                    .toList();
              }
              isInit = false;
              return ListView.builder(
                itemCount: settingDataList == null ? 0 : settingDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      new SettingTile(
                        settingData: settingDataList[index],
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }),
      );
    });
  }

  Future _fetchSettingsList(BuildContext contex) async {
    if (!isInit) {
      return null;
    }

    if (myUser == null) {
      // 유저 정보 없으면 오류.
      return null;
    }

    var data = await _nodeConnector.getWithNonAuth(kGetSettingList);

    var resultData = data[0]["results"];

    if (resultData == null) {
      print('here null');
      return null;
    }

    print('resultData');
    print(resultData);
    var parsed = resultData.cast<Map<String, dynamic>>();

    return parsed;
  }
}
