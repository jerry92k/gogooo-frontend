import 'package:flutter/material.dart';

class FeedItem extends StatefulWidget {
  @override
  _FeedItemState createState() => _FeedItemState();
  String profileImageName;
  String participantName;
  String image;
  String interestId;
  String interestNm;
  String hashTags;
  String experience;
  bool isLiked;

  FeedItem({
    this.profileImageName,
    this.participantName,
    this.image,
    this.interestId,
    this.interestNm,
    this.hashTags,
    this.experience,
    this.isLiked,
  });
}

class _FeedItemState extends State<FeedItem> {
  // 더보기 버튼
  bool hasMore = true;
  String firstHalf;
  String secondHalf;

  // 좋아요 버튼
  bool isLiked;

  final double favoriteSize = 15.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 더보기 버튼
    // 1) 이미지+글 : 2줄 이상일 때
    // 2) 글만 : 5줄 이상일 때
    int point;
    if (widget.image.isEmpty) {
      point = 140;
    } else {
      point = 60;
    }

    if (widget.experience.length > point) {
      firstHalf = widget.experience.substring(0, point);
      secondHalf = widget.experience.substring(point, widget.experience.length);
    } else {
      firstHalf = widget.experience;
      secondHalf = "";
    }

    // 좋아요 버튼
    isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 12, right: 8),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 작성자
                Row(
                  children: <Widget>[
                    // 프로필 이미지
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(widget.profileImageName),
                        ),
                      ),
                    ),
                    // 작성자 이름
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        widget.participantName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // 사진
                widget.image.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(top: 4),
                        child: Column(
                          children: <Widget>[
                            Image.network(widget.image),
                          ],
                        ),
                      )
                    : Container(),
                // 후기
                Container(
                  child: secondHalf.isEmpty
                      ? new Container(
                          child: Text(firstHalf),
                        )
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(hasMore
                                ? (firstHalf + "...")
                                : (firstHalf + secondHalf)),
                            new InkWell(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Text(
                                    hasMore ? "더보기" : "줄이기",
                                    style:
                                        new TextStyle(color: Color(0xffb7b7b7)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  hasMore = !hasMore;
                                });
                              },
                            ),
                          ],
                        ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // 좋아요
                      new Container(
                        width: 12.0,
                        height: 12.0,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              isLiked ? isLiked = false : isLiked = true;
                            });
                          },
                          child: isLiked
                              ? Icon(
                                  Icons.favorite,
                                  color: Color(0xffff3939),
                                  size: favoriteSize,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: favoriteSize,
                                ),
                        ),
                      ),
                      // 댓글
                      Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: favoriteSize,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          // 가로 구분선 영역
          Container(
            height: 1,
            color: Color(0xffeeeeee),
          ),
        ],
      ),
    );
  }
}
