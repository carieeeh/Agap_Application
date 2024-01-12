import 'package:agap_mobile_v01/router/route_list.dart';
import 'package:agap_mobile_v01/services/auth_service.dart';
import 'package:agap_mobile_v01/services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => SettingService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      title: 'Agap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        primaryColor: Colors.white,
      ),
      initialRoute: '/login',
      getPages: routeList,
    );
  }
}
