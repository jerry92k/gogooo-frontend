import 'package:sqflite/sqflite.dart';

//TODO : db connection을 싱글톤으로 하는게 맞을까?
// node 인스턴스가 여러개 생성되면.. singleton 효율 떨어지는건 아닐까?

// Singleton 클래스여서 application에서 공유함.
class SqliteHelper {
  static final SqliteHelper _sqliteHelper = SqliteHelper._createInstance();

  static Database database;

  SqliteHelper._createInstance(); //Dart에서 _로 시작하는 것은 private를 의미합니다.

  //Use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class. For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.
  factory SqliteHelper() {
    return _sqliteHelper;
  }

  //SqliteHelper();

  String _path;

  void initDatabase() async {
    if (database == null) {
      var databasesPath = await getDatabasesPath();
      _path = '${databasesPath}/gogooo/chats.db';
    }
  }

  void openConnection() async {
    database = await openDatabase(_path, version: 2);
  }

  Database getDatabase() {
    return database;
  }

  void deleteDB() async {
    await deleteDatabase(_path);
  }

  void createChatTable() async {
    await openConnection();
    String query = 'CREATE TABLE IF NOT EXISTS CHAT' +
        '( MEETING_ID INTEGER NOT NULL' + // 모임 ID
        ', MESSAGE_ID INTEGER NOT NULL' + // 메세지 ID
        ', SENDER_ID INTEGER NOT NULL' + // 송신자 ID
        ', PHOTO_YN INTEGER NOT NULL' + // 사진유무. 0:false, 1:true
        ', PAYLOAD TEXT NOT NULL' + // 사진일 경우 경로.
        ', INPUT_DTTM INTEGER NOT NULL' + // 입력일시
        ', CHECK_YN INTEGER NOT NULL' +
        ', PRIMARY KEY(MEETING_ID,MESSAGE_ID))'; // 읽음 유무. 0:false, 1:true

    // 최초등록일시와 최종수정일시를 넣으려다가, 어차피 유저 로컬에 생성되는 파일이니 디버깅도 할수없고.. 쓸필요가 없다고 판단함
    await database.execute(query);
    await closeConnection();
  }

  void insertChatData(String query, List<dynamic> arguments) async {
    // id => 마지막으로 Insert된 레코드 id 반환
    //print(query);
    await openConnection();

    int id;
    //  await database.transaction((txn) async {
    id = await database.rawInsert(query, arguments);
    // });
    await closeConnection();
    //print(id);
    //return id;
  }

  void insertChatDataMulti(String query, List<dynamic> arguments) async {
    // id => 마지막으로 Insert된 레코드 id 반환
    //print(query);
    int id;
    //  await database.transaction((txn) async {
    id = await database.rawInsert(query, arguments);
    // });
    //print(id);
    //return id;
  }

  void updateChatData(String query) async {
    // count => update된 레코드 갯수
    await openConnection();

    int count = await database.rawUpdate(query);
    print('updated: $count');
    await closeConnection();
    // return count;
  }

  void updateChatDataMulti(String query) async {
    // count => update된 레코드 갯수

    int count = await database.rawUpdate(query);
    print('updated: $count');
    // return count;
  }

  Future selectMultiState(String query) async {
    List<Map> list = await database.rawQuery(query);

    return list;
  }

  Future selectSingleSql(String query) async {
    await openConnection();
    List<Map> list = await database.rawQuery(query);
    await closeConnection();
    return list;
  }

  void deleteData(String query) async {
    await openConnection();
    int count = await database.rawDelete(query);
    await closeConnection();
  }

  void closeConnection() async {
    await database.close();
    database = null;
  }
}
