//회원가입 라우터
const String kSignUp = '/users/auth/applyJoin';
const String kGetProfileIcons = '/profiles/profile-icons';

//이메일 중복체크 라우터
const String kcheckDupEmail = '/users/auth/check-dup/email';

//이메일 중복체크 라우터
const String kcheckDupName = '/users/auth/check-dup/name';

// 로그인 라우터
const String kLogin = '/users/auth/login';

// 토큰 리프레쉬 라우터
const String kRefresh = '/users/auth/refresh';

// 모임만들기 라우터
const String kCreateMeetingPlan = '/meetings';

String getkJoinMeetingPath(int userId, int meetingId) {
  return '/users/${userId}/join/meetings/${meetingId}';
}

// 모임참여취소하기 라우터
String getkleaveMeetingPath(int userId, int meetingId) {
  return '/users/${userId}/leave/meetings/${meetingId}';
}

String getkSendMsgRoute(int meetingId) {
  return '/meetings/${meetingId}/chat';
}

String getkPartiesInMeet(int userId, int meetingId) {
  return '/users/${userId}/meetings/${meetingId}';
}

// 읽지않은 메시지 가져오기
String getkUnreadChats(int meetingId, int lastReadId) {
  return '/meetings/${meetingId}/chats?lastReadId=${lastReadId}';
}

String getkMeetInfo(int meetingId) {
  return '/meetings/${meetingId}/users';
}

String getkMeetList(int userId, int maxMeetId, int lastIdx) {
  return '/users/$userId/meetings/$maxMeetId/$lastIdx';
}

String getkUserRecords(int userId) {
  return '/users/${userId}/records';
}

String getkMySpaceMeets(int userId, String lastPath) {
  return '/users/$userId/meetings/$lastPath/';
}

// 내 프로필 가져오기
const String kUserData = '/users/profile';

// 내 프로필 만들기 라우터
const String kCreateUserProfile = '/users/profile';

String kMaxMeetId = '/meetings/maxId';

String kGetInterestCategoryList = '/interests/all';
String kGetInterestIcons = '/interests/interest-icons';

// 설정탭 리스트 조회 라우터
String kGetSettingList = '/settings/all';

// 설정탭 - 공지사항 리스트 조회 라우터
String kGetNoticeList = '/settings/notice/all';

// 설정탭 - 공지사항상세내용 조회 라우터
String kGetNoticeDetailList(int noticeId) {
  return '/settings/notice/$noticeId';
}

// 설정탭 - 계정관리 리스트 조회 라우터
String kGetAccountManagementList = '/settings/account-mng/all';

// 설정탭 - 계정관리 - 비밀번호 변경 라우터
const String kUpdateUserPassword = '/users/auth/password-change';

// 토큰 테스트
const String kTokenTest = '/users/auth/testToken';
