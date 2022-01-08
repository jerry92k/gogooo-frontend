import 'package:intl/intl.dart';

class Chat {
  int senderId; // 0 : system
  String profileImgPath; //'' : system
  String senderName;
  String text; // message
  int inputDttm;
  String inputDate;
  String inputTime;
  //final String inputTime;

  Chat(int senderId, String profileImgPath, String senderName, String text,
      int inputDttm) {
    this.senderId = senderId;
    this.profileImgPath = profileImgPath;
    this.senderName = senderName;
    this.text = text;
    this.inputDttm = inputDttm;

    if (inputDttm > 0) {
      setDateTime();
    }
  }
  setDateTime() {
    var dateFormat = new DateFormat('yyyy년 MM월 dd일 EEE');
    var timeFormat = new DateFormat('HH:mm');

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(inputDttm * 1000);
    inputDate = dateFormat.format(dateTime);
    inputTime = timeFormat.format(dateTime);
  }
}
