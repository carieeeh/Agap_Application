import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final AuthController _authService = Get.find<AuthController>();

  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    return _authService.isAuth.value
        ? null
        : const RouteSettings(name: '/login');
  }
}
