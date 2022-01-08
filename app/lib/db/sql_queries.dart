/*
String kInsertChatQuery(int MEETING_ID, int MESSAGE_ID, int SENDER_ID,
    int PHOTO_YN, String PAYLOAD, int INPUT_DTTM, int CHECK_YN) {
  String query =
      'INSERT INTO CHAT(MEETING_ID,MESSAGE_ID,SENDER_ID,PHOTO_YN,PAYLOAD' +
          ',INPUT_DTTM,CHECK_YN) VALUES(${MEETING_ID},${MESSAGE_ID},${SENDER_ID},${PHOTO_YN},\'${PAYLOAD}\',${INPUT_DTTM},${CHECK_YN});';
  return query;
}
*/
const kInsertChatQuery =
    'INSERT INTO CHAT(MEETING_ID,MESSAGE_ID,SENDER_ID,PHOTO_YN,PAYLOAD,INPUT_DTTM,CHECK_YN) ' +
        'VALUES(?,?,?,?,?,?,?);';

String kSelectChatQuery(int meetingId) {
  String query =
      'SELECT MESSAGE_ID,SENDER_ID,PHOTO_YN,PAYLOAD,INPUT_DTTM,CHECK_YN ' +
          'FROM CHAT ' +
          'WHERE MEETING_ID=$meetingId ' +
          'ORDER BY MESSAGE_ID DESC';
  return query;
}

String kCheckDupMessage(int meetingId, int msgId) {
  String query =
      'SELECT CASE WHEN COUNT(*)> 0 THEN \'Y\' ELSE \'N\' END AS IS_DUP ' +
          'FROM CHAT ' +
          'WHERE MEETING_ID=$meetingId ' +
          'AND MESSAGE_ID=$msgId ';
  return query;
}

String kSelectMaxMessageIdQuery(int meetingId) {
  String query = 'SELECT MAX(MESSAGE_ID) AS MAX_ID ' +
      'FROM CHAT ' +
      'WHERE MEETING_ID=$meetingId';
  return query;
}

String kdeleteChatAll() {
  String query = 'DELETE FROM CHAT';
  return query;
}
