import 'package:favorite_restaurant_app/common/styles.dart';
import 'package:favorite_restaurant_app/data/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    // _getDailyNewsPreferences();
    _getDailyReminderPreferences();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  // bool _isDailyNewsActive = false;
  // bool get isDailyNewsActive => _isDailyNewsActive;

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  // void _getDailyNewsPreferences() async {
  //   _isDailyNewsActive = await preferencesHelper.isDailyNewsActive;
  //   notifyListeners();
  // }

  void _getDailyReminderPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  // void enableDailyNews(bool value) {
  //   preferencesHelper.setDailyNews(value);
  //   _getDailyNewsPreferences();
  // }

  void enableDailyReminder(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminderPreferences();
  }
}
