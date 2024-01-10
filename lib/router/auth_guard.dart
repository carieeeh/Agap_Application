import 'package:agap_mobile_v01/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final AuthService authService = Get.find<AuthService>();

  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    return authService.autheticated.value
        ? null
        : const RouteSettings(name: '/login');
  }
}
