import 'package:app/constants/image_constants.dart';

/* 공지사항 리스트 데이터  */
class NoticeData {
  int id;
  String title;
  String contents;
  String date; // yyyy.mm.dd
  String ap; // 오전, 오후
  String time; // h:mi

  NoticeData(this.id, this.title, this.contents, this.date, this.ap, this.time);

  NoticeData.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        title = json['TITLE'],
        contents = json['CONTENTS'],
        date = json['DATE'],
        ap = json['AP'],
        time = json['TIME'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'contents': contents,
        'date': date,
        'ap': ap,
        'time': time,
      };
}
