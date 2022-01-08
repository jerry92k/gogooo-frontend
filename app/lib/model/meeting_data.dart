import 'package:app/constants/image_constants.dart';

class MeetingData {
  //TODO : 메인탭에서 meetinglist 데이터 읽어올때, MEETING 테이블과 USER_LIKE_MEETING을
  // 조인해서 liked여부 읽어오기

  int meetingId;
  String image;
  //bool isLiked;
  String likeYn;
  int interestId;
  String interestNm;
  String hashTags;
  String meetingTitle;
  String locationTitle;
  String locationAddress;
  //String meetingLocation;
  String longitude;
  String latitude;
  int numOfPeople;
  int maxUserNum;
  String meetingDate;
  String description;
  int organizerId;
  String organizerNm;
  String organizerYn;
  String joinYn;

  //TODO:organizerID;

  MeetingData({
    this.meetingId,
    this.image,
    //this.isLiked,
    this.likeYn,
    this.interestId,
    this.interestNm,
    this.hashTags,
    this.meetingTitle,
    this.locationTitle,
    this.locationAddress,
    this.longitude,
    this.latitude,
    this.numOfPeople,
    this.maxUserNum,
    this.meetingDate,
    this.description,
    this.organizerId,
    this.organizerNm,
    this.organizerYn,
    this.joinYn,
  });

  MeetingData.fromJson(Map<String, dynamic> json)
      : meetingId = json['MEETING_ID'],
        image = kInterestIconsBasePath + json['INTEREST_IMG_FILE_NM'],
        likeYn = json['LIKE_YN'],
        interestId = json['INTEREST_ID'],
        interestNm = json['INTEREST_NM'],
        hashTags = json['HASH_TAGS'],
        meetingTitle = json['MEETING_TITLE'],
        locationTitle = json['LOCATION_TITLE'],
        locationAddress = json['LOCATION_ADDRESS'],
        longitude = json['LONGITUDE'],
        latitude = json['LATITUDE'],
        numOfPeople = json['NUM_OF_PEOPLE'],
        maxUserNum = json['MAX_USER_NUM'],
        meetingDate = json['MEETING_DATE'],
        description = json['DESCRIPTION'],
        organizerId = json['ORGANIZER_ID'],
        organizerNm = json['ORGANIZER_NM'],
        organizerYn = json['ORGANIZER_YN'],
        joinYn = json['JOIN_YN'];

  Map<String, dynamic> toJson() => {
        'meetingId': meetingId,
        'image': image,
        //'isLiked': isLiked,
        'likeYn': likeYn,
        'interestId': interestId,
        'interestNm': interestNm,
        'hashTags': hashTags,
        'meetingTitle': meetingTitle,
        'locationTitle': locationTitle,
        'locationAddress': locationAddress,
        'longitude': longitude,
        'latitude': latitude,
        'numOfPeople': numOfPeople,
        'maxUserNum': maxUserNum,
        'meetingDate': meetingDate,
        'description': description,
        'organizerId': organizerId,
        'organizerNm': organizerNm,
        'organizerYn': organizerYn,
        'joinYn': joinYn,
      };
}
