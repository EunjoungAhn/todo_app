import 'dart:developer';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notification = FlutterLocalNotificationsPlugin();

class AppNotificationService {
  String alarmId;
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    //final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  Future<void> initializeNotification() async {
    // 안드로이드 초기화
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios 초기화 - 모두 false로 알림을 추가 할때 알림 권한 묻기
    const initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // 안드로이드 ios 초기화 담기
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(
      initializationSettings,
    );
  }

  // 알람 시간을 받아와서 스트링으로 변환
  String alarmIdMethod(int alarmId) {
    return alarmId.toString();
  }

  Future<bool> addNotifcication({
    int id,
    String alarmTimeStr,
    String title, // HH:mm 메모를 확인해주세요!
    String body, // {메모 제목}
  }) async {
    if (!await permissionNotification) { // addNotifcication을 호출하면 permission을 묻는다.
      // show native setting page - 내가 알람권한이 없으면 설정창으로 가서 알림권한을 추가해줘
      return false;
    }

    /// exception
    final now = tz.TZDateTime.now(tz.local);
    final alarmTime = DateFormat('HH:mm').parse(alarmTimeStr);
    final day = (alarmTime.hour < now.hour ||
        alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1
        : now.day;

    /// id
    alarmId = alarmIdMethod(id);

    /// add schedule notification
    final details = _notificationDetails(
      alarmId, // unique
      title: title,
      body: body,
    );

    await notification.zonedSchedule(
      int.parse(alarmId), // unique
      title,
      body,
      tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        day,
        alarmTime.hour,
        alarmTime.minute,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: alarmId,
    );
    log('[notification list] ${await pendingNotificationIds}');

    return true;
  }

  NotificationDetails _notificationDetails(
      String id, {
        String title,
        String body,
      }) {
    final android = AndroidNotificationDetails(
      id,
      title,
      channelDescription: body,
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = IOSNotificationDetails();

    return NotificationDetails(
      android: android,
      iOS: ios,
    );
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return true; // 안드로이드 일때는 있다.
    } else if (Platform.isIOS) {
      // ios 일때는 아래의 권한이 있는지 묻는다.
      return await notification
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else {
      // 안드로이드 or ios가 아니면 false로 반환
      return false;
    }
  }

// 다중 알람 삭제 매서드
  Future<void> deleteMultipleAlarm(Iterable<String> alarmIds) async {
    log('[before delete notification list] ${await pendingNotificationIds}');
    for (final alarmId in alarmIds) {
      final id = int.parse(alarmId);
      await notification.cancel(id);
    }
    log('[after delete notification list] ${await pendingNotificationIds}');
  }

  // 단일 알림 삭제 매서드
  Future<void> deleteAlarm(String alarmId) async {
    //log('[before delete notification list] ${await pendingNotificationIds}');
    final id = int.parse(alarmId);
    await notification.cancel(id, tag: "d");
    //log('[after delete notification list] ${await pendingNotificationIds}');
  }

  Future<List<int>> get pendingNotificationIds {
    final list = notification
        .pendingNotificationRequests()
        .then((value) => value.map((e) => e.id).toList());
    return list;
  }
}