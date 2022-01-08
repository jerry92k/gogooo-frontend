import 'package:app/constants/image_constants.dart';

class Interest {
  int interestIconId;
  int interestId;
  String interestNm;
  String image;
  bool isSelected;

  Interest(
      {this.interestIconId,
      this.interestId,
      this.interestNm,
      this.image,
      this.isSelected = false});

  Interest.fromJson(Map<String, dynamic> json)
      : interestIconId = json['INTEREST_ICON_ID'],
        interestId = json['INTEREST_ID'],
        interestNm = json['INTEREST_NM'],
        image = kInterestIconsBasePath + json['INTEREST_IMG_FILE_NM'],
        isSelected = false;

  Map<String, dynamic> toJson() => {
        'interestIconId': interestIconId,
        'interestId': interestId,
        'interestNm': interestNm,
        'image': image,
        'isSelected': isSelected,
      };

  void toggleSelected() {
    isSelected = !isSelected;
  }
}
