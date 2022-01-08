import 'package:app/screen/feed_screen.dart';
import 'package:app/screen/meeting_screen.dart';
import 'package:app/screen/my_space_screen.dart';
import 'package:app/screen/settings_screen.dart';
import 'package:flutter/material.dart';

//void main() => runApp(TabControllerComponent());

class TabControllerComponent extends StatefulWidget {
  static String id = '/tab_controller_component';
  static const String _title = '공공모임';

  @override
  _TabControllerComponentState createState() => _TabControllerComponentState();
}

class _TabControllerComponentState extends State<TabControllerComponent> {
  @override
  void initState() {
    super.initState();
  }

  int bottomSelectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue);

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      // onPageChanged: (index) {
      //   pageChanged(index);
      // },
      children: <Widget>[
        bottomSelectedIndex == 0 ? MeetingScreen() : Container(),
        bottomSelectedIndex == 1 ? FeedScreen() : Container(),
        bottomSelectedIndex == 2 ? MySpaceScreen() : Container(),
        bottomSelectedIndex == 3 ? SettingsScreen() : Container(),
      ],
    );
  }

  // void pageChanged(int index) {
  //   setState(() {
  //     bottomSelectedIndex = index;
  //   });
  // }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff191919),
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(color: Colors.white70),
              ),
        ), // sets the inactive color of the `BottomNavigationBar`

        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('모임'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speaker_notes),
              title: Text('피드'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars),
              title: Text('내공간'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('설정'),
            ),
          ],
        ),
      ),
    );
  }
}
