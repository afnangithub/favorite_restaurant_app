import 'dart:io';
import 'package:favorite_restaurant_app/ui/settings_page.dart';
import 'package:favorite_restaurant_app/ui/z_favorites_page.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_detail_page.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_list_page.dart';
import 'package:favorite_restaurant_app/ui/z_search_page.dart';
import 'package:favorite_restaurant_app/utils/notification_helper.dart';
import 'package:favorite_restaurant_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageX extends StatefulWidget {
  static const routeName = '/home_page';
  @override
  _HomePageStateX createState() => _HomePageStateX();
}

class _HomePageStateX extends State<HomePageX> {
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Restaurants';
  final NotificationHelper _notificationHelper = NotificationHelper();
  List<Widget> _listWidget = [
    RestaurantListPage(),
    SearchPage(),
    FavoritesPage(),
    SettingsPage()
  ];
  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
        icon:
            Icon(Platform.isIOS ? CupertinoIcons.placemark_fill : Icons.place),
        label: _headlineText),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.search : Icons.search),
        label: FavoritesPage.favoritesTitle),
    BottomNavigationBarItem(
        icon:
            Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite_border),
        label: FavoritesPage.favoritesTitle),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
        label: SettingsPage.settingsTitle),
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
            onTap: _onBottomNavTapped));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: _bottomNavBarItems),
        tabBuilder: (context, index) {
          return _listWidget[index];
        });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
