import 'dart:ui';
import 'dart:isolate';
import 'package:favorite_restaurant_app/main.dart';
// import 'package:favorite_restaurant_app/data/api/api_service.dart';
import 'package:favorite_restaurant_app/data/api/restaurant_api_service.dart';
import 'package:favorite_restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

// class BackgroundRestaurantService {
//   static BackgroundRestaurantService? _instance;
//   static String _isolateName = 'isolate';
//   static SendPort? _uiSendPort;

//   BackgroundRestaurantService._internal() {
//     _instance = this;
//   }

//   factory BackgroundRestaurantService() =>
//       _instance ?? BackgroundRestaurantService._internal();

//   void initializeIsolate() {
//     IsolateNameServer.registerPortWithName(
//       port.sendPort,
//       _isolateName,
//     );
//   }

//   static Future<void> callback() async {
//     print('Alarm Reminder!');
//     final NotificationRestaurantHelper _notificationHelper =
//         NotificationRestaurantHelper();
//     var result = await r_api.ApiService().listRestaurant();
//     await _notificationHelper.showNotification(
//         flutterLocalNotificationsPlugin, result);

//     _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
//     _uiSendPort?.send(null);
//   }
// }

class BackgroundService {
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiService().listRestaurant();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
