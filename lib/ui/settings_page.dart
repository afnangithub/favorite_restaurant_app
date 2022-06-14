import 'dart:io';

import 'package:favorite_restaurant_app/provider/preferences_provider.dart';
import 'package:favorite_restaurant_app/provider/scheduling_provider.dart';
import 'package:favorite_restaurant_app/widgets/custom_dialog.dart';
import 'package:favorite_restaurant_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(settingsTitle)), body: _buildList(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(settingsTitle)),
        child: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (context, provider, child) {
      return ListView(
        children: [
          Material(
              child: ListTile(
                  title: Text('Dark Theme'),
                  trailing: Switch.adaptive(
                      value: provider.isDarkTheme,
                      onChanged: (value) {
                        provider.enableDarkTheme(value);
                      }))),
          Material(
              child: ListTile(
                  title: Text('Scheduling Restaurant Reminder'),
                  // title: Text('Scheduling News'),
                  trailing: Consumer<SchedulingProvider>(
                      builder: (context, scheduled, _) {
                    return Switch.adaptive(
                        value: provider.isDailyReminderActive,
                        // value: provider.isDailyNewsActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledReminder(value);
                            provider.enableDailyReminder(value);
                          }
                        });
                  }))),
          // Material(
          //   child: ListTile(
          //     title: Text('Scheduling Restaurant Favrite '),
          //     trailing: Consumer<SchedulingRestaurantProvider>(
          //       builder: (context, scheduled, _) {
          //         return Switch.adaptive(
          //             value: provider.isDailyReminderActive,
          //             onChanged: (value) async {
          //               if (Platform.isIOS) {
          //                 customDialog(context);
          //               } else {
          //                 scheduled.scheduledReminder(value);
          //                 provider.enableDailyReminder(value);
          //               }
          //             });
          //       },
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
