# gogooo 앱

- 개발언어 : Flutter

## 프로젝트 구조

```bash
gogooo
├── app # Flutter 프로젝트
|   ├── android
|   ├── fonts # 폰트
|   |   ├── KaiGenGothicKR-Light.ttf
|   |   ├── KaiGenGothicKR-Medium.ttf
|   |   └── KaiGenGothicKR-Regular.ttf
|   ├── images # 이미지
|   |   ├── 1.5x
|   |   ├── 2.0x
|   |   ├── 3.0x
|   |   ├── 4.0x
|   |   ├── interest-icons # 모임 카테고리 아이콘 (모임탭 화면에서 사용)
|   |   |   ├── icon_coffee_01.png # 아이콘_커피
|   |   |   ├── icon_culture_01.png # 아이콘_문화
|   |   |   ├── icon_food_01.png  # 아이콘_음식
|   |   |   └── ...
|   |   ├── profile-icons # 프로필 아이콘 (행성)
|   |   |   ├── cha_earth.png # 캐릭터_얼쓰
|   |   |   ├── cha_jupiter.png # 캐릭터_주피터
|   |   |   └── ...
|   |   ├── background-meeting-001.png
|   |   ├── division_line.png
|   |   ├── info_mailpw.png # 가입인증메일 비밀번호 설정안내
|   |   └── symbol.png # 로그인용 태양계 이미지
|   ├── ios
|   |
|   ├── lib # 공통 라이브러리
|   |   ├── components # 공통 컴포넌트
|   |   |   ├── alert_button.dart # 확인버튼
|   |   |   ├── back_button_leading_appbar.dart # 뒤로가기 앱바
|   |   |   ├── custom_alertdialog.dart # (내용없음)
|   |   |   ├── dropdown.dart # 드롭다운
|   |   |   ├── feed_item.dart # 피드 아이템
|   |   |   ├── icon_and_text.dart # 아이콘포함 텍스트
|   |   |   ├── location_data.dart # 지역정보
|   |   |   ├── meeting_item.dart # 모임 아이템
|   |   |   ├── naver_api_connector.dart # 네이버 API 연결
|   |   |   ├── participant.dart # 참가인원
|   |   |   ├── popup_appbar.dart # 팝업 앱바
|   |   |   ├── post_button.dart # 등록 버튼
|   |   |   ├── question_text.dart # 질문 텍스트
|   |   |   ├── rsa_helper.dart # RSA 암호화 수행 모듈
|   |   |   ├── star_profile_row.dart # 행성프로필
|   |   |   ├── tab_controller_component.dart # 탭화면 컨트롤러
|   |   |   ├── underline_textfield.dart # 밑줄 텍스트
|   |   |   └── upload_photo_icon.dart # 사진올리기
|   |   |
|   |   ├── constants # 상수
|   |   |   ├── constants.dart
|   |   |   └── image_constants.dart # 이미지파일 정보
|   |   |
|   |   ├── screen # 화면
|   |   |   ├── complete_request_screen.dart # 회원가입완료 화면
|   |   |   ├── enroll_profile_step1_screen.dart # 회원가입_프로필행성선택 화면
|   |   |   ├── enroll_profile_step2_screen.dart # 회원가입_기본정보입력 화면
|   |   |   ├── enroll_profile_step3_screen.dart # 회원가입_관심분야선택 화면
|   |   |   ├── feed_post_screen.dart # 피드작성 화면
|   |   |   ├── feed_screen.dart # 피드탭 화면
|   |   |   ├── load_screen.dart # 로딩 화면
|   |   |   ├── login_screen.dart # 로그인 화면
|   |   |   ├── meeting_detail_screen.dart # 모임상세 화면
|   |   |   ├── meeting_plan_screen.dart # 모임계획 화면
|   |   |   ├── meeting_screen.dart # 모임탭 화면
|   |   |   ├── my_space_screen.dart # 내공간탭 화면
|   |   |   ├── settings_screen.dart # 설정탭 화면
|   |   |   ├── signup_screen.dart # 회원가입 화면
|   |   |   └── star_profile.dart # 행성프로필소개 화면 (삭제예정)
|   |   |
|   |   ├── main.dart
|   |   ├── method_utils.dart
|   |   └── popup_layout.dart
|   |
|   ├── test
|   ├── .gitignore
|   ├── .metadata
|   ├── README.md
|   ├── pubspec.lock
|   └── pubspec.yaml # 패키지 의존성 관리 및 프로젝트 정의
└── README.md
```
