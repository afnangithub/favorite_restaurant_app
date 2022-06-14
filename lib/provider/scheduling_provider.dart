import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:favorite_restaurant_app/utils/background_service.dart';
import 'package:favorite_restaurant_app/utils/date_time_helper.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledReminder(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
//      print('Scheduling News Activated');
      print('Scheduling Restaurant Favrite Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Restaurant Favrite Canceled');
      // print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}

// class SchedulingRestaurantProvider extends ChangeNotifier {
//   bool _isScheduled = false;

//   bool get isScheduled => _isScheduled;

//   Future<bool> scheduledReminder(bool value) async {
//     _isScheduled = value;
//     if (_isScheduled) {
//       print('Scheduling Restaurant Favrite Activated');
//       notifyListeners();
//       return await AndroidAlarmManager.periodic(
//         Duration(hours: 24),
//         1,
//         BackgroundService.callback,
//         startAt: DateTimeHelper.format(),
//         exact: true,
//         wakeup: true,
//       );
//     } else {
//       print('Scheduling Restaurant Favrite Canceled');
//       notifyListeners();
//       return await AndroidAlarmManager.cancel(1);
//     }
//   }
// }
