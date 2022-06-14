import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:favorite_restaurant_app/common/navigation.dart';
import 'package:favorite_restaurant_app/data/api/api_service.dart';
import 'package:favorite_restaurant_app/data/api/restaurant_api_service.dart'
    as ra;
import 'package:favorite_restaurant_app/data/db/database_helper.dart';
import 'package:favorite_restaurant_app/data/db/restaurant_database_helper.dart';
import 'package:favorite_restaurant_app/data/model/article.dart';
import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:favorite_restaurant_app/data/preferences/preferences_helper.dart';
import 'package:favorite_restaurant_app/provider/database_provider.dart';
import 'package:favorite_restaurant_app/provider/database_restaurant_provider.dart';
import 'package:favorite_restaurant_app/provider/news_provider.dart';
import 'package:favorite_restaurant_app/provider/restaurant_provider.dart'
    as rp;
import 'package:favorite_restaurant_app/provider/preferences_provider.dart';
import 'package:favorite_restaurant_app/provider/scheduling_provider.dart';
import 'package:favorite_restaurant_app/ui/article_detail_page.dart';
import 'package:favorite_restaurant_app/ui/article_web_view.dart';
import 'package:favorite_restaurant_app/ui/home_page.dart';
import 'package:favorite_restaurant_app/ui/z_home_page.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_detail_page.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_search_page.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_view.dart';
import 'package:favorite_restaurant_app/utils/background_service.dart';
import 'package:favorite_restaurant_app/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  // final NotificationRestaurantHelper _notificationRestaurantHelper =
  //     NotificationRestaurantHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyAppX());
}

class MyAppX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                rp.ListRestaurantProvider(apiService: ra.ApiService()),
          ),
          ChangeNotifierProvider(create: (_) => SchedulingProvider()),
          ChangeNotifierProvider(
              create: (_) => PreferencesProvider(
                  preferencesHelper: PreferencesHelper(
                      sharedPreferences: SharedPreferences.getInstance()))),
          ChangeNotifierProvider(
              create: (_) => DatabaseRestaurantProvider(
                  restaurantDatabaseHelper: RestaurantDatabaseHelper()))
        ],
        child:
            Consumer<PreferencesProvider>(builder: (context, provider, child) {
          return MaterialApp(
              title: 'Favorite Restaurant App',
              theme: provider.themeData,
              builder: (context, child) {
                return CupertinoTheme(
                    data: CupertinoThemeData(
                        brightness: provider.isDarkTheme
                            ? Brightness.dark
                            : Brightness.light),
                    child: Material(child: child));
              },
              navigatorKey: navigatorKey,
              initialRoute: HomePageX.routeName,
              routes: {
                HomePageX.routeName: (context) => HomePageX(),
                RestaurantDetailPage.routeName: (context) =>
                    RestaurantDetailPage(
                        restaurant: ModalRoute.of(context)?.settings.arguments
                            as Restaurant),
                RestaurantView.routeName: (context) => RestaurantView(
                    id: ModalRoute.of(context)?.settings.arguments as String),
                RestaurantSearchPage.routeName: (context) =>
                    RestaurantSearchPage(
                        query: ModalRoute.of(context)?.settings.arguments
                            as String)
              });
        }));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: provider.themeData,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                      provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                    article:
                        ModalRoute.of(context)?.settings.arguments as Article,
                  ),
              ArticleWebView.routeName: (context) => ArticleWebView(
                    url: ModalRoute.of(context)?.settings.arguments as String,
                  ),
            },
          );
        },
      ),
    );
  }
}
