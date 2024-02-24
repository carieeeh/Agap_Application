import 'package:agap_mobile_v01/global/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    return _authService.autheticated.value
        ? null
        : const RouteSettings(name: '/login');
  }
}
