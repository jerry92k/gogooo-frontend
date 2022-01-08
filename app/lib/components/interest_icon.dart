import 'package:app/constants/image_constants.dart';
import 'package:flutter/material.dart';

class InterestIcon extends StatelessWidget {
  final int interestIconId;
  final int interestId;
  final String interestNm;
  final String image;
  bool isSelected;
  final Function onSelectedCallback;

  InterestIcon({
    this.interestIconId,
    this.interestId,
    this.interestNm,
    this.image,
    this.isSelected,
    this.onSelectedCallback,
  });

  //final double favoriteSize = 15.0;
  final double iconSize = 17.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 10.0),
//      padding: EdgeInsets.only(left: 18, top: 4, right: 18, bottom: 4),
      child: Stack(
        children: <Widget>[
          // 네모 박스
          Positioned(
            child: Container(
              alignment: Alignment.center,
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(top: 10.0, right: 10.0),
              //padding: const EdgeInsets.all(1.0),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Color(0xff1ed69e),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                    )
                  : BoxDecoration(),
              child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: onSelectedCallback,
                  child: Image.asset(
                    image ?? '${kInterestIconsBasePath}cha-earth_1.png',
                    //width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )),
            ),
          ),
          // 체크 버튼
          Positioned(
            top: -10,
            right: -30,
            child: isSelected
                ? new MaterialButton(
                    height: 20,
                    shape: new CircleBorder(),
                    elevation: 0.0,
                    padding: EdgeInsets.all(2),
                    color: Color(0xff1ed69e),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {},
                    //onPressed: onSelectedCallback,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
