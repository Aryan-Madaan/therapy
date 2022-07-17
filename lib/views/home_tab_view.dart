import 'package:flutter/material.dart';
import 'package:therapy/views/homepage.dart';
import 'package:therapy/data/data.dart';
import 'package:therapy/views/rehab.dart';
import 'dart:math';

class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  int _selectedIndex = 0;
  bool isDisabled = false;
  ValueKey<int> changeKey = const ValueKey(0);
  List<dynamic> screens = [];
  final HomePageData _homePageData = HomePageData();
  _HomeTabViewState() {
    screens = [
      HomePage(_homePageData),
      Rehab(_homePageData),
      const Center(child: Text('Practice')),
      const Center(child: Text('Profile')),
    ];
  }

  Widget createFloatingActionButton(context) {
    return FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 41, 117, 231),
        onPressed: () async {
          if (!isDisabled) {
            isDisabled = true;
            await _homePageData.addData();
            await _homePageData.fetchData();
            setState(() {
              changeKey = ValueKey(Random().nextInt(100));
              screens[0] = HomePage(
                _homePageData,
              );
              if (_homePageData.sessionsCompleted <
                  _homePageData.totalSessions) {
                isDisabled = false;
              }
            });
          }
        },
        extendedIconLabelSpacing: 0,
        extendedPadding:
            EdgeInsetsDirectional.all(MediaQuery.of(context).size.width / 5.5),
        label: const Text(
          "Start Session",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        icon: const Icon(
          Icons.arrow_right_outlined,
          size: 50,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        key: changeKey,
        body: screens[_selectedIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            _selectedIndex == 0 ? createFloatingActionButton(context) : null,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() {
            _selectedIndex = i;
            changeKey = ValueKey(Random().nextInt(100));
          }),
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(255, 110, 109, 109),
          enableFeedback: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_outlined,
              ),
              activeIcon: Icon(
                Icons.calendar_month_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_outlined),
              activeIcon: Icon(Icons.accessibility_outlined),
              label: 'Rehab',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_outlined),
              label: 'Practice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
