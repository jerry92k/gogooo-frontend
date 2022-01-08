import 'package:app/components/popup_appbar.dart';
import 'package:app/components/star_profile_row.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:flutter/material.dart';

class StarProfileScreen extends StatelessWidget {
  static String id = '/star_profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PopupAppBar(
        title: '행성 캐릭터 소개',
        isElevation: 1.0,
      ),
      body: Container(
        margin: kBodyMargin,
        child: ListView(
          children: buildStarProfile(),
        ),
      ),
    );
  }

  List<Widget> buildStarProfile() {
    List<Widget> starList = List<Widget>();

    starIconName.forEach((icon, name) => starList.add(StarProfileRow(
          image: icon,
          name: name,
          comment: starIconComment[icon],
        )));
    return starList;
  }

  final Map<String, String> starIconComment = {
    kEarthIcon: '너그럽고 이해심 많은 센스쟁이',
    kJupiterIcon: '활발하고 리더십을 소유한 인싸',
    kMarsIcon: '수줍음이 많지만 용감한 친구',
    kMercuryIcon: '운동과 여행을 좋아하는 언변가',
    kNeptuneIcon: '바다를 좋아하는 자유인',
    kPlutoIcon: '눈에 잘 띄진 않지만 올바른 선택을 하는 현인',
    kSaturnIcon: '여유있고 현명한 친구',
    kUranusIcon: '자기만의 개성이 있는 친구',
    kVinusIcon: '자기관리에 철저한 열정인',
  };

  final Map<String, String> starIconName = {
    kEarthIcon: '얼스',
    kJupiterIcon: '주피터',
    kMarsIcon: '마르스',
    kMercuryIcon: '머큐리',
    kNeptuneIcon: '넵튠',
    kPlutoIcon: '플루토',
    kSaturnIcon: '새턴',
    kUranusIcon: '우라노스',
    kVinusIcon: '비너스',
  };
}
