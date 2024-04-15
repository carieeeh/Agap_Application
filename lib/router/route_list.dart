import 'package:agap_mobile_v01/layout/private/rescuer/home/report_details.dart';
import 'package:agap_mobile_v01/layout/private/resident/dashboard/dashboard.dart';
import 'package:agap_mobile_v01/layout/private/resident/home/homepage.dart';
import 'package:agap_mobile_v01/layout/private/resident/home/rescuer_map_view.dart';
import 'package:agap_mobile_v01/layout/private/resident/profile/profile.dart';
import 'package:agap_mobile_v01/layout/private/resident/reports/reports_list.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/dashboard/rescuer_dashboard.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/home/rescuer_interactive_map.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/profile/rescuer_profile.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/reports/rescuer_reports_list.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/settings/rescuer_settings.dart';
import 'package:agap_mobile_v01/layout/private/resident/settings/settings.dart';
import 'package:agap_mobile_v01/layout/public/login.dart';
import 'package:agap_mobile_v01/layout/public/otp_page.dart';
import 'package:agap_mobile_v01/layout/public/registration.dart';
import 'package:agap_mobile_v01/layout/public/splash_screen.dart';
import 'package:agap_mobile_v01/router/auth_guard.dart';
import 'package:get/get.dart';

List<GetPage> routeList = [
  GetPage(
    name: '/home',
    page: () => const HomePage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/rescuer_map_view',
    page: () => const RescuerMapView(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/interactive_map',
    page: () => const RescuerInteractiveMap(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/report_details',
    page: () => const ReportDetails(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/dashboard',
    page: () => const Dashboard(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/rescuer_dashboard',
    page: () => const RescuerDashboard(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/reports',
    page: () => const ReportsList(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/rescuer_reports',
    page: () => const RescuerReportsList(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/rescuer_settings',
    page: () => const RescuerSettingsPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/profile',
    page: () => const Profile(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/rescuer_profile',
    page: () => const RescuerProfile(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '/login',
    page: () => const LoginPage(),
  ),
  GetPage(
    name: '/otp-page',
    page: () => const OTPPage(),
  ),
  GetPage(
    name: '/registration',
    page: () => const RegistrationPage(),
  ),
  GetPage(name: "/", page: () => const SplashScreen()),
];
