import 'package:get/get.dart';

class AuthService extends GetxService {
  RxBool autheticated = false.obs;

  Future<AuthService> init() async {
    print('$runtimeType delays 2 sec');
    await 2.delay();
    print('$runtimeType ready!');
    return this;
  }
}
