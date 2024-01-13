import 'package:get/get.dart';

class AuthService extends GetxService {
  RxBool autheticated = true.obs;
  RxBool isRescuer = true.obs;

  Future<AuthService> init() async {
    return this;
  }
}
