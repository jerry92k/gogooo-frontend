import 'package:flutter/material.dart';

class InterestCategoryItem extends StatelessWidget {
  final String interestCategoryId;
  final String interestCategoryNm;
  bool isSelected;
  final Function onSelectedCallback;

  InterestCategoryItem({
    this.interestCategoryId,
    this.interestCategoryNm,
    this.isSelected,
    this.onSelectedCallback,
  });

  final double favoriteSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 8, top: 2, right: 8),
      child: Container(
        child: Stack(
          children: <Widget>[
            // 박스
            Positioned(
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: 110,
                //padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xff1ed69e) : Colors.white,
                  border: Border.all(
                    color: isSelected ? Color(0xff1ed69e) : Color(0xffb7b7b7),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(
                          15.0) //                 <--- border radius here
                      ),
                ),
                child: MaterialButton(
                  onPressed: onSelectedCallback,
                  child: Text(
                    interestCategoryNm,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // 카테고리 타이틀
          ],
        ),
      ),
    );
  }
}
