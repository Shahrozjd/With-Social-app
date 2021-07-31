import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:with_app/pages/add_page.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/profile_page.dart';
import 'package:with_app/pages/timeline_page.dart';
import 'package:with_app/pages/user_timeline_page.dart';
import 'package:with_app/styles/custom_color.dart';

PersistentBottomBarState mypresistentbottombarstate;

class BottomBarPage extends StatefulWidget {

  static const String id = 'BottomBarPage';
  const BottomBarPage({Key key}) : super(key: key);

  @override
  PersistentBottomBarState createState() {
    mypresistentbottombarstate = PersistentBottomBarState();
    return mypresistentbottombarstate;
  }
}

class PersistentBottomBarState extends State<BottomBarPage> {
  PersistentTabController controller;

  @override
  void initState() {
    controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      TimelinePage(),
      AddPage(),
      UserTimelinePage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: Icon(Icons.home),
        // title: ("Home"),
        activeColorPrimary: CustomColor.secColor,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: Icon(Octicons.list_unordered),
        // title: ("Category"),
        activeColorPrimary: CustomColor.secColor,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: Icon(Icons.add),
        // title: ("Account"),
        activeColorPrimary: CustomColor.secColor,
        inactiveColorPrimary: Colors.white,
      ),

      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: Icon(FontAwesome5.house_user,size: 22,
        ),
        // title: ("Account"),
        activeColorPrimary: CustomColor.secColor,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FontAwesome.user),
        iconSize: 25,
        activeColorPrimary: CustomColor.secColor,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: CustomColor.primaryColor,
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),

      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style9, // Cho
    );
  }
}