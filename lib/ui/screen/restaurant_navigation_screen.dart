import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/notification_helper.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_detail_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_favorite_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_main_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_setting_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/platform_widget.dart';

class RestaurantNavigationScreen extends StatefulWidget {
  static const routeName = '/restaurant_navigation';

  const RestaurantNavigationScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantNavigationScreen> createState() =>
      _RestaurantNavigationScreenState();
}

class _RestaurantNavigationScreenState
    extends State<RestaurantNavigationScreen> {
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Home';
  final NotificationHelper _notificationHelper = NotificationHelper();
  final List<Widget> _listWidget = [
    const RestaurantMainScreen(),
    const RestaurantFavoriteScreen(),
    const RestaurantSettingScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS
            ? CupertinoIcons.square_favorites_alt
            : Icons.favorite),
        label: 'Favorite'),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: 'Setting',
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: _bottomNavBarItems,
        ),
        tabBuilder: (context, index) {
          return _listWidget[index];
        });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }
}
