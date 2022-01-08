import 'package:app/components/fixed_bottom.dart';
import 'package:app/components/back_button_leading_appbar.dart';
import 'package:app/components/post_button.dart';
import 'package:app/components/underline_textfield.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/image_constants.dart';
import 'package:app/constants/routes_constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:app/model/profile_icon.dart';
import 'package:app/network/node_connector.dart';
import 'package:app/utils/method_utils.dart';
import 'package:app/screen/enroll_profile_step3_screen.dart';
import 'package:flutter/material.dart';

class EnrollProfileStep2Screen extends StatefulWidget {
  static String id = '/enroll_profile_step2_screen';

  @override
  _EnrollProfileStep2ScreenState createState() =>
      _EnrollProfileStep2ScreenState();
}

enum GenderTpcd {
  male,
  female,
  star,
}

ProfileIcon profileIcon;

class _EnrollProfileStep2ScreenState extends State<EnrollProfileStep2Screen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  //String _name = '';

  TextEditingController _nickCtrl = TextEditingController();

  void getArgument(BuildContext context) {
    Step1Arguments step1Arguments = ModalRoute.of(context).settings.arguments;
    profileIcon = step1Arguments.profileIcon;
  }

  @override
  Widget build(BuildContext context) {
    getArgument(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '기본정보 입력',
        ),
        leading: BackButtonLeadingAppbar(),
        centerTitle: true,
      ),
      body: Container(
        margin: kBodyMargin,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              buildRichText(),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '닉네임과 성별 입력',
                style: kEnrollProfileCategoryTextStyle,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(child: Image.asset(profileIcon.profileImgFileNm)),
              SizedBox(
                height: 20.0,
              ),
              buildFieldLabel('닉네임'),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: UnderLineTextField(
                        controller: _nickCtrl,
                        hintText: '너그러운 얼스',
                        onChanged: (value) {
                          // if (value.toString().length < _name.length) {
                          //   setState(() {
                          //     _isUniqueID = '';
                          //   });
                          // }
                          setState(() {
                            _isUniqueID = '';
                            //  _name = value;
                            //   _nickCtrl.text = _name;
                          });
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 20.0,
                            color: Color(0xffb7b7b7),
                          ),
                          onPressed: () {
                            setState(() {
                              _nickCtrl.text = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      //width: kNickNameValidateSize,
                      child: OutlineButton(
                        onPressed: () {
                          checkDup();
                        },
                        //TODO: 서버가서 user의 name 필드 확인
                        child: Text("중복확인"),
                        borderSide: BorderSide(color: Color(0xffb7b7b7)),
                        //shape: StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  _isUniqueID == ''
                      ? '품격있게 욕설과 비속어는 사용하지 말기로 해요.'
                      : _isUniqueID == 'true'
                          ? '사용가능한 닉네임입니다.'
                          : '이미 사용중인 닉네임 입니다.',
                  style: TextStyle(
                    color: Color(_isUniqueID == ''
                        ? 0xff4545f1
                        : _isUniqueID == 'true'
                            ? 0xff4545f1
                            : 0xffff3939),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              buildFieldLabel('성별'),
              // buildGenders(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buildGenders(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: FixedBottom(getButtonList(context)),
    );
  }

  String _isUniqueID = '';
  Future checkDup() async {
    var bodyContents = {
      'name': _nickCtrl.text,
    };

    NodeConnector _nodeConnector = NodeConnector();
    var data =
        await _nodeConnector.postWithNonAuth(kcheckDupName, bodyContents);

    print('get data');
    print(data);

    setState(() {
      _isUniqueID = data['isUnique'];
    });
  }

  GenderTpcd selectedGender = GenderTpcd.star;

  Map<GenderTpcd, String> genderText = {
    GenderTpcd.female: '여성',
    GenderTpcd.male: '남성',
    GenderTpcd.star: '행성',
  };

  List<Widget> buildGenders() {
    List<Widget> buttons = List<Widget>();

    for (GenderTpcd gender in GenderTpcd.values) {
      buttons.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  selectedGender = gender;
                  // print('selectedGender : $selectedGender');
                });
              },
              child: Text(
                genderText[gender],
                style: TextStyle(),
              ),
              textColor:
                  selectedGender == gender ? Colors.white : Color(0xff000000),
              color:
                  selectedGender == gender ? Color(0xff1ed69e) : Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xffb7b7b7), width: 0.5)),
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Container buildFieldLabel(String label) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        label,
        style: kFieldTitleTextStyle,
      ),
    );
  }

  RichText buildRichText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'STEP 2',
            style: kLightTextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: '/3',
            style: kLightTextStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> getButtonList(BuildContext context) {
    return [
      Expanded(
        flex: 3,
        child: new Builder(builder: (BuildContext snackContext) {
          return PostButton(
            text: '다음',
            onPressed: () async {
              await checkDup();
              if (_isUniqueID != 'true') {
                Scaffold.of(snackContext)
                    .showSnackBar(getSnackBar('유효한 닉네임을 입력해주세요.'));

                return;
              }
              String _sex = genderText[selectedGender];
              Navigator.pushNamed(context, EnrollProfileStep3Screen.id,
                  arguments: Step2Arguments(
                      profileIcon: profileIcon,
                      name: _nickCtrl.text,
                      sex: _sex));
            },
          );
        }),
      ),
    ];
  }
}

class Step1Arguments {
  final ProfileIcon profileIcon;

  Step1Arguments(this.profileIcon);
}
