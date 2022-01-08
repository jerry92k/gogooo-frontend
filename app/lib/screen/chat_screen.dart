import 'dart:convert';

import 'package:app/arguments/ChatArgument.dart';
import 'package:app/components/chat_message.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/db/sql_queries.dart';
import 'package:app/db/sqlite_helper.dart';
import 'package:app/model/chat.dart';
import 'package:app/model/my_user.dart';
import 'package:app/model/my_user_data.dart';
import 'package:app/model/user.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/network/socket_base.dart';
import 'package:app/utils/PreferenceUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';

  ChatArgument chatArguments;

  ChatScreen({this.chatArguments});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
// TODO 4: 소켓io통신, streambuilder로 구현해야하는지 확인
// TODO : 스크롤 올렸을때 동적으로 메세지 더 읽어오기
// TODO : 채팅방 상단에 모임명 넣어주기. 푸쉬를 통해서 들어온 경우면 모임참가자리스트 읽어올때 같이 읽어오

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  // 전송버튼에 적용할 색상으로 이용
  accentColor: Colors.orangeAccent[400],
);

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//  TODO : meetingId 변수화
  int meetingId = 2;
  List<User> users = [];
  // 입력한 메시지를 저장하는 리스트

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  //List<Map> _chatUserList = <Map>[];
  List<Chat> _chatList = [];

  String _text = '';

  SqliteHelper _db;
  NodeConnector _nodeConnector;

  SocketBase chatSocket;
  //var futureFetch;

  //MyUser myUser;
  bool isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //dbDeleteTest();
    _db = SqliteHelper();
    _db.initDatabase();
    _nodeConnector = NodeConnector();
    //  futureFetch = _initChats();
    // TODO: 안읽은 채팅있으면 읽음 표시로 변경
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("reach the top");
      });
    }
  }

  void initChatSocket() async {
    var query = {'meetingId': meetingId};
    print('here 1');
    chatSocket = new SocketBase(kChatSocket, meetingId);

    print('here 2');
    //chatSocket.getSocket().connect();
    print('here 3');

    //TODO : meeting_detail_screen에서 모임 참여하기 눌렀을때, join data날리는 거 구현
    chatSocket.getSocket().on('join', (data) {
      print(data);
    });

    chatSocket.getSocket().on('textMsg', (data) {
      if (data['senderId'] == 0) {
        //User chatUser = getChatUser(data['senderId']);
        addNewChat(data, '', kSystemName);
      } else {
        print('senderId');
        print(data['senderId']);
        User chatUser = getChatUser(data['senderId']);
        print(chatUser.name);
        print(chatUser.profileImgPath);
        addNewChat(data, chatUser.profileImgPath, chatUser.name);
      }
    });
  }

  void addNewChat(var data, String profileImgPath, String senderName) async {
    int meetingId = int.parse(data['meetingId']);
    await _db.insertChatData(kInsertChatQuery, [
      meetingId,
      data['msgId'],
      data['senderId'],
      data['photoYn'],
      data['chatMsg'],
      data['inputTime'],
      1
    ]);

    Chat chat = Chat(data['senderId'], profileImgPath, senderName,
        data['chatMsg'], data['inputTime']);
    setState(() {
      _chatList.insert(0, chat);
    });
  }

  Future _initChats() async {
    //이전 화면에서 넘겨받는 모임 사용자 리스트

    if (!isInit) {
      return null;
    }

    print('here start 11');

    if (widget.chatArguments != null) {
      meetingId = widget.chatArguments.meetingId;
      users = widget.chatArguments.users;

      if (users.length <= 0) {
        users = await fetchUsers();
        print('userlist');
        print(users);
      }
    } else {
      // 문제 있는 상황.load화면으로 돌아가야할까?
    }

    // TODO: Test 끝나면 주석 풀기
    //meetingId = chatArguments.meetingId;
    print('my meetingId is : $meetingId');

    await _db.openConnection();
    //await dbInsertTest();
    //TODO : meetingID의 마지막 msgId를 서버로 보내서 클라이언트의 마지막 msgId보다 앞선것 보내
//kSelectMaxMessageIdQuery
    var maxData =
        await _db.selectMultiState(kSelectMaxMessageIdQuery(meetingId));
    int maxId = maxData[0]['MAX_ID'];
    print('maxData');
    print(maxData);
    print(maxId);
    //기존에 받았던 메세지가 있으면, 서버에가서 메세지 읽어오기
    if (maxId != null && maxId > 0) {
      List<Map> newChatDatas = await fetchUnreadChats(maxId);

      for (Map<String, dynamic> chat in newChatDatas) {
        //newChatDatas.forEach((chat) async{
        await _db.insertChatDataMulti(kInsertChatQuery, [
          chat['MEETING_ID'],
          chat['MESSAGE_ID'],
          chat['SENDER_ID'],
          chat['PHOTO_YN'],
          chat['PAYLOAD'],
          chat['INPUT_DTTM'],
          1
        ]);
      }
    }

    List<Map> chatdatas =
        await _db.selectMultiState(kSelectChatQuery(meetingId));
    print('chats');
    print(chatdatas);
    await _db.closeConnection();
    return chatdatas;
  }

  MyUser myUser;

  @override
  Widget build(BuildContext context) {
    widget.chatArguments = ModalRoute.of(context).settings.arguments;
    return Consumer<MyUserData>(builder: (context, myUserData, child) {
      myUser = myUserData.myUser;
      //  print('here');
      // print(myUserData.myUser.id);
      //myUser = myUserData.myUser;
      return Scaffold(
        appBar: AppBar(
          title: Text('Friendlychat'),
          // appBar 하단의 그림자 정도
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
        ),
        body: FutureBuilder(
            future: _initChats(),
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

                List<Map> chatDatas = snapshot.data;
                print(chatDatas);

                String inputDate = '';
                chatDatas.forEach((chat) {
                  User chatUser = getChatUser(chat['SENDER_ID']);

                  //TODO : chat 내역에는 있는 user id 이지만, user-meeting db에는 없는 사용자. 어떻게 기준을 정하는게 좋을까?
                  Chat newChat;
                  if (chatUser == null) {
                    newChat = Chat(chat['SENDER_ID'], '', '알수없음',
                        chat['PAYLOAD'], chat['INPUT_DTTM']);
                  } else {
                    newChat = Chat(chat['SENDER_ID'], chatUser.profileImgPath,
                        chatUser.name, chat['PAYLOAD'], chat['INPUT_DTTM']);
                  }

                  if (inputDate != '' &&
                      inputDate != newChat.inputDate) // 제일 첫 메세지가 아니면
                  {
                    Chat dateChat = Chat(
                        0, // system
                        '', // no image
                        'system',
                        inputDate,
                        0);
                    _chatList.add(dateChat);
                  }

                  inputDate = newChat.inputDate;
                  _chatList.add(newChat);
                });

                //제일 첫 메세지 날짜를 제일 상단에 넣어
                if (inputDate == '') {
                  var dateFormat = new DateFormat('yyyy년 MM월 dd일 E');

                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch);
                  inputDate = dateFormat.format(DateTime.now());
                }
                Chat dateChat = Chat(
                    0, // system
                    '', // no image
                    'system',
                    inputDate,
                    0);
                _chatList.add(dateChat);

                //setState로 다시 발드할경우 재실행되지 않게 하기 위한 코드
                //futureFetch = null;
                isInit = false;
                initChatSocket();
              }

              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // 리스트뷰를 Flexible로 추가.
                    Container(
                      child: Flexible(
                        child: ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가됨
                            reverse: true,
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: _chatList == null ? 0 : _chatList.length,
                            itemBuilder: (BuildContext context, int index) {
                              String basePath = "images/profile-icons/";

                              /*
                              ㅇ head(아이콘이 있는 경우) : 1) 마지막 메세지인경우, 2) 다음 메세지 senderId가 다른경우, 3) 다음 메세지 time이 다른 경우
                               */
                              bool hasHead = false;

                              Chat chat = _chatList[index];

                              if (index >= _chatList.length - 1) {
                                // 마지
                                hasHead = true;
                              } else {
                                // 첫번째가 아님
                                Chat postChat = _chatList[index + 1];
                                if (postChat.senderId != chat.senderId ||
                                    postChat.inputTime != chat.inputTime) {
                                  hasHead = true;
                                }
                              }

                              /*
                              ㅇ time(타임스탭프 있는경우) : 1) 마지막 메세지인경우, 2) 이전 chat의 senderId가 다른경우, 3) 이전 chat의 time이 다른경우
                               */
                              bool hasTail = false;
                              if (index < 1) {
                                // 첫번
                                hasTail = true;
                              } else {
                                //마지막아님
                                Chat preChat = _chatList[index - 1];
                                if (preChat.senderId != chat.senderId ||
                                    preChat.inputTime != chat.inputTime) {
                                  hasTail = true;
                                }
                              }

                              ChatMessage chatMessage = ChatMessage(
                                chat: chat,
                                isMine: myUserData.myUser.id == chat.senderId,
                                hasHead: hasHead,
                                hasTail: hasTail,
                                animationController: AnimationController(
                                  duration: Duration(milliseconds: 3),
                                  vsync: this,
                                ),
                              );
                              chatMessage.animationController.forward();

                              return chatMessage;
                            }
                            //_message[index],
                            ),
                      ),
                    ),
                    // 구분선
                    Divider(height: 1.0),
                    // 메시지 입력을 받은 위젯(_buildTextCompose)추가
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: _buildTextComposer(),
                    )
                  ],
                ),
                // iOS의 경우 데코레이션 효과 적용
                decoration: Theme.of(context).platform == TargetPlatform.iOS
                    ? BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Colors.grey[200])))
                    : null,
              );
            }),
      );
    });
  }

  User getChatUser(int Id) {
    for (User user in users) {
      if (user.id == Id) {
        return user;
      }
    }
    return null;
  }

  // 사용자로부터 메시지를 입력받는 위젯 선언
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // 텍스트 입력 필드
            Expanded(
              flex: 4,
              child: Container(
                child: TextField(
                  controller: _textController,
                  // 입력된 텍스트에 변화가 있을 때 마다
                  onChanged: (text) {
                    setState(() {
                      print('input text');
                      print(text);
                      _text = text;
                      //_isComposing = text.length > 0;
                    });
                  },
                  // 키보드상에서 확인을 누를 경우. 입력값이 있을 때에만 _handleSubmitted 호출
                  onSubmitted: _text.isNotEmpty ? _handleSubmitted : null,
                  // 텍스트 필드에 힌트 텍스트 추가
                  decoration:
                      InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
            ),
            // 전송 버튼
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                // 플랫폼 종류에 따라 적당한 버튼 추가
                child:
                    /* Theme.of(context).platform == TargetPlatform.iOS
                    ? MaterialButton(
                        child: Text("send"),
                        onPressed: _text.isNotEmpty
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    :*/
                    IconButton(
                  // 아이콘 버튼에 전송 아이콘 추가
                  icon: Icon(Icons.send),
                  // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                  onPressed: _text.isNotEmpty
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메시지 전송 버튼이 클릭될 때 호출
  //TODO : 내가 메세지 보낸거 받을때까지 대기표시 필요
  void _handleSubmitted(String text) async {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    // _isComposing을 false로 설정
    setState(() {
      _text = '';
      //_isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    //TODO : 1. socket으로 다시 리턴받은 데이터를 확인하고 그려주는 걸로 수정 필

    //chatSocket.getSocket().emit('textMsg', text);

    var bodyContents = {
      'sId': chatSocket.getSocket().id,
      'chatMsg': text,
    };

    var data = await _nodeConnector.postWithAuth(
        getkSendMsgRoute(meetingId), bodyContents);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    chatSocket.getSocket().dispose();
    super.dispose();
  }

  void dbDeleteTest() async {
    await _db.initDatabase();
    await _db.deleteData(kdeleteChatAll());
  }

  void dbInsertTest() async {
    await _db.initDatabase();
  }

  void dbCreateTest() async {
    try {
      await _db.initDatabase();
      // await dbInsertTest();
      //await _db.deleteDB();
      _db.createChatTable();
    } catch (error) {
      print(error);
    }
  }

  Future<List> fetchUsers() async {
    int userId = myUser.id;
    print('userID [$userId]');

    var data = await _nodeConnector
        .getWithNonAuth(getkPartiesInMeet(userId, meetingId));
    print('userlist');
    print(data);
    var usersData = data[0]["results"];
    var parsed = usersData.cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<List> fetchUnreadChats(int lastReadId) async {
    print('fetch unread data start');
    print(getkUnreadChats(meetingId, lastReadId));
    var data = await _nodeConnector
        .getWithNonAuth(getkUnreadChats(meetingId, lastReadId));
    var chatData = data[0]["results"];
    print('receive data');
    print(chatData);
    var parsed = chatData.cast<Map<String, dynamic>>();
    //return parsed.map<User>((json) => User.fromJson(json)).toList();
    return parsed;
  }
}
