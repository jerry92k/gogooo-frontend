import 'package:app/model/user.dart';

class ChatArgument {
  final int meetingId;
  final List<User> users;

  ChatArgument(this.meetingId, this.users);
}
