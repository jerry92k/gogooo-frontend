import 'package:flutter/material.dart';

class ProfileIconItem extends StatelessWidget {
  final int profileIconId;
  final int profileId;
  final String profileNm;
  final String image;
  bool isSelected;
  final Function onSelectedCallback;

  ProfileIconItem({
    this.profileIconId,
    this.profileId,
    this.profileNm,
    this.image,
    this.isSelected,
    this.onSelectedCallback,
  });

  final double iconSize = 17.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
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
                    image ?? './images/profile-icons/cha-earth_1.png',
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
    /*],
      ),
    );*/
  }
}
