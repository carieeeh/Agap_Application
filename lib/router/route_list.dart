import 'package:agap_mobile_v01/layout/private/dashboard/dashboard.dart';
import 'package:agap_mobile_v01/layout/private/home/homepage.dart';
import 'package:agap_mobile_v01/layout/private/profile/profile.dart';
import 'package:agap_mobile_v01/layout/private/reports/report_feedback.dart';
import 'package:agap_mobile_v01/layout/private/reports/reports_list.dart';
import 'package:agap_mobile_v01/layout/private/settings/settings.dart';
import 'package:agap_mobile_v01/layout/public/login.dart';
import 'package:agap_mobile_v01/layout/public/registration.dart';
import 'package:agap_mobile_v01/router/auth_guard.dart';
import 'package:get/get.dart';

List<GetPage> routeList = [
  GetPage(
    name: '/',
    page: () => const HomePage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/dashboard',
    page: () => const Dashboard(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/reports',
    page: () => const ReportsList(),
    middlewares: [AuthGuard()],
    children: [
      GetPage(
        name: '/feedback',
        page: () => const ReportFeedback(),
      ),
    ],
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/profile',
    page: () => const Profile(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/login',
    page: () => const LoginPage(),
  ),
  GetPage(
    name: '/registration',
    page: () => const RegistrationPage(),
  ),
];
