import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/icon_and_text.dart';
import 'package:app/components/location_data.dart';
import 'package:app/components/popup_appbar.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/components/upload_photo_icon.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/network/naver_api_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPostScreen extends StatefulWidget {
  static String id = '/feed_plan_screen';

  @override
  _FeedPostScreenState createState() => _FeedPostScreenState();
}

class _FeedPostScreenState extends State<FeedPostScreen> {
  String _date;
  String _location;
  String _numOfPeople;
  String _price;
  String _comment;

  NaverAPIConnector naverAPIConnector = NaverAPIConnector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PopupAppBar(
        title: '피드 작성',
        color: Color(0xffe8eaf6),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            buildPrimeInfoForms(),
            buildDetailInfoForms(),
          ],
        ),
      ),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  Container buildPrimeInfoForms() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Color(0xffe8eaf6),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              '모임명',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 모임명
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: '모임명을 입력하세요\n40자 이내',
                      hintStyle: TextStyle(
                        //letterSpacing: 5.0,
                        height: 1.2,
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '모임명을 입력하세요. (40자 이내)';
                      }
                      return null;
                    },
                  ),
                ),
                UploadPhotoIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDetailInfoForms() {
    return Container(
      margin: kBodyMargin,
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          // 카테고리
          Container(
            child: buildDropDownMenu(),
          ),
          // 모임일시
          SizedBox(
            height: 20.0,
          ),
          IconAndText(
            icon: Icons.date_range,
            title: '일시',
          ),
          UnderLineTextField(
            hintText: '2020.03.15 오후 2:32',
            //textInputType: TextInputType.emailAddress,
            onChanged: (value) {
              _date = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return '..';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          IconAndText(
            icon: Icons.location_on,
            title: '장소',
          ),
          UnderLineTextField(
            hintText: '장소를 입력하세요',
            onChanged: (value) {
              _location = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return '..';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          IconAndText(
            icon: Icons.group,
            title: '인원',
          ),
          UnderLineTextField(
            hintText: '인원을 입력하세요',
            onChanged: (value) {
              _numOfPeople = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return '..';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          IconAndText(
            icon: Icons.account_balance_wallet,
            title: '회비',
          ),
          UnderLineTextField(
            hintText: '회비 입력하세요',
            onChanged: (value) {
              _price = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return '..';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          IconAndText(
            icon: Icons.chat_bubble_outline,
            title: '코멘트',
          ),
          Container(
            child: TextFormField(
              maxLines: 2,
              style: kUnderlineTextFieldTextStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '#태그, 내용을 자유롭게 입력하세요',
              ),
              onChanged: (value) {
                _comment = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '#태그, 내용을 자유롭게 입력하세요';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: PostButton(
          text: '포스트하기',
          onPressed: () {},
        ),
      ),
    ];
  }

  Container buildDropDownMenu() {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        height: 25.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Color(0xffb7b7b7), style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            hint: Text(
              '카테고리 선택',
              style: kFieldTitleTextStyle,
            ),
            items: [
              DropdownMenuItem(
                value: '1',
                child: Text(
                  '사교',
                ),
              ),
              DropdownMenuItem(
                value: '2',
                child: Text(
                  '맛집',
                ),
              ),
              DropdownMenuItem(
                value: '3',
                child: Text(
                  '공연전시',
                ),
              ),
              DropdownMenuItem(
                value: '4',
                child: Text(
                  '커피',
                ),
              ),
            ],
            onChanged: (String value) {},
          ),
        ));
  }
}
