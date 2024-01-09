import 'package:agap_mobile_v01/layout/private/homepage.dart';
import 'package:agap_mobile_v01/layout/public/login.dart';
import 'package:agap_mobile_v01/router/router.dart';
import 'package:agap_mobile_v01/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Get.putAsync(() => AuthService().init());
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final RouteList _routeList = RouteList();
    
    return MaterialApp.router(
      title: 'Agap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      routerConfig: _routeList.router,
    );
  }
}
