class LocationData {
  String title = '';
  String roadAddress = '';
  String longitude = '';
  String latitude = '';

  LocationData({
    this.title,
    this.roadAddress,
    this.longitude,
    this.latitude,
  });

  /*
address_name: 경기 남양주시 와부읍 도곡리 504-15,
place_name: 스타벅스 리버사이드팔당DTR점,
road_address_name: 경기 남양주시 와부읍 경강로 772,
x: 127.22837062241311,
y: 37.56711341785411

 */
  LocationData.fromJson(Map<String, dynamic> json)
      : title = json['place_name'],
        //json['place_name'].toString().replaceAll(new RegExp(r'(<b>|</b>)'), ''),
        // : title = json['title'],
        roadAddress = json['road_address_name'],
        longitude = json['x'],
        latitude = json['y'];
  // longitude = json['mapx'],
  // latitude = json['mapy'];
}
