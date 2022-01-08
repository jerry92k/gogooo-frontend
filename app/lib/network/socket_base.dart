import 'dart:convert';

import 'package:app/utils/PreferenceUtils.dart';
import 'package:app/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketBase {
  IO.Socket _socket;

  SocketBase(String socketUrl, int meetingId) {
    String accessToken = PreferenceUtils.getString(kAccessToken);
    if (accessToken == null) {
      print('accessToken이 없습니다');
      throw Error();
    }
    var accessTokenDcd = jsonDecode(accessToken);

    print(socketUrl);
    print('accesstoken');
    print(accessTokenDcd['token']);
    _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket']).setExtraHeaders({
          'Authorization': accessTokenDcd['token'],
          'meetingId': meetingId
        }) // optional
            //  .setQuery(query)
            .build());

    print('here 4');

    _socket.connect();
    _socket.onConnect((_) {
      print('connected');
      // socket.emit('msg', 'test');
    });

    _socket.on('connect', (_) {
      print('Connected');
    });
    _socket.on('disconnect', (error) {
      print(error);
      print('Disconnected');
    });

    _socket.on('error', (data) {
      print(data);
    });
    _socket.on('connect_error', (error) {
      print(error);
      print('connect_error');
    });

    _socket.on('connect_timeout', (_) {
      print('connect_timeout');
    });
    _socket.on('connecting', (_) {
      print('connecting');
    });

    _socket.on('eixt', (data) {});
  }

  IO.Socket getSocket() {
    return _socket;
  }

//void createSocketConnection() async {}
}
