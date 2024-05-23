import 'package:agap_mobile_v01/firebase_options.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/notification_controller.dart';
import 'package:agap_mobile_v01/global/controller/profile_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/rescuer_controller.dart';
import 'package:agap_mobile_v01/global/controller/resident_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/global/controller/storage_controller.dart';
import 'package:agap_mobile_v01/router/route_list.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 2,
      channelKey: "rescuer_channel",
      title: message.data["title"],
      body: message.data["message"],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize("resource://drawable/res_icon", [
    NotificationChannel(
      channelGroupKey: "rescuer_group_channel",
      channelKey: "rescuer_channel",
      channelName: "Rescuer Channel",
      channelDescription: "Channel for Rescuer",
      playSound: true,
      enableVibration: true,
      criticalAlerts: true,
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      soundSource: "resource://raw/res_agap_sound",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "rescuer_group_channel",
      channelGroupName: "rescuers",
    )
  ]);

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

// TODO: Attribute links
// <a href="https://www.flaticon.com/free-animated-icons/earthquake" title="earthquake animated icons">Earthquake animated icons created by Freepik - Flaticon</a>
// TODO: SHA1: 55:16:D1:00:8F:92:6E:D4:C4:AE:70:F4:0C:E3:DA:5D:E7:95:B3:B2 for Firebase
// to get sha 1 keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayMethod,
    );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Get.put(AuthController());
    Get.put(SettingsController());
    Get.put(LocationsController());
    Get.put(StorageController());
    Get.put(ReportController());
    Get.put(RescuerController());
    Get.put(ResidentController());
    Get.put(ProfileController());

    return GetMaterialApp(
      title: 'Agap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        primaryColor: Colors.white,
      ),
      initialRoute: '/',
      getPages: routeList,
    );
  }
}
