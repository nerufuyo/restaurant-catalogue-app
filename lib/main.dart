import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/database_helper.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/notification_helper.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/preference_helper.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/preference_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_database_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_detail_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_search_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/scheduling_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/background_service.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/navigation.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_detail_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_favorite_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_navigation_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_search_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_setting_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializedIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RestaurantDatabaseApi _api = RestaurantDatabaseApi();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantProvider>(
              create: (_) => RestaurantProvider(api: _api)),
          ChangeNotifierProvider<RestaurantSearchProvider>(
            create: (_) => RestaurantSearchProvider(api: _api),
          ),
          ChangeNotifierProvider<RestaurantDetailProvider>(
              create: (_) => RestaurantDetailProvider(api: _api)),
          ChangeNotifierProvider<RestaurantDatabaseProvider>(
            create: (_) =>
                RestaurantDatabaseProvider(databaseHelper: DatabaseHelper()),
          ),
          ChangeNotifierProvider(
              create: (_) => PreferenceProvider(
                  preferenceHelper: PreferenceHelper(
                      sharedPreferences: SharedPreferences.getInstance()))),
          ChangeNotifierProvider<SchedulingProvider>(
              create: (_) => SchedulingProvider()),
        ],
        child: Consumer<PreferenceProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Restaurant Catalogue',
                theme: provider.themeData,
                builder: (context, child) {
                  return CupertinoTheme(
                      data: CupertinoThemeData(
                        brightness: provider.isDarkTheme
                            ? Brightness.dark
                            : Brightness.light,
                      ),
                      child: Material(
                        child: child,
                      ));
                },
                navigatorKey: navigatorKey,
                initialRoute: SplashScreen.routeName,
                routes: {
                  SplashScreen.routeName: (context) => const SplashScreen(),
                  RestaurantNavigationScreen.routeName: (context) =>
                      const RestaurantNavigationScreen(),
                  RestaurantFavoriteScreen.routeName: (context) =>
                      const RestaurantFavoriteScreen(),
                  RestaurantSearchScreen.routeName: (context) =>
                      const RestaurantSearchScreen(),
                  RestaurantDetailScreen.routeName: (context) =>
                      RestaurantDetailScreen(
                        restaurant: ModalRoute.of(context)?.settings.arguments
                            as Restaurants,
                      ),
                  RestaurantSettingScreen.routeName: (context) =>
                      const RestaurantSettingScreen(),
                });
          },
        ),
      );
}
