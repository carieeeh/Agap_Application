import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/global/controller/storage_controller.dart';
import 'package:agap_mobile_v01/router/route_list.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );

  runApp(const MyApp());
}

// TODO: Attribute links
// <a href="https://www.flaticon.com/free-animated-icons/earthquake" title="earthquake animated icons">Earthquake animated icons created by Freepik - Flaticon</a>
// TODO: SHA1: 55:16:D1:00:8F:92:6E:D4:C4:AE:70:F4:0C:E3:DA:5D:E7:95:B3:B2 for Firebase
// to get sha 1 keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Get.put(SettingsController());
    Get.put(AuthController());
    Get.put(LocationsController());
    Get.put(StorageController());
    Get.put(ReportController());

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
