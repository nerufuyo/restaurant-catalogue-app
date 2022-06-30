// ignore_for_file: avoid_print

import 'dart:isolate';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:restaurant_catalog_submission_akhir/main.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializedIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await RestaurantDatabaseApi().getTopHeadLines(Client());
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
