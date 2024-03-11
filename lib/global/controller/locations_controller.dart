import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationsController extends GetxController {
  RxBool isPermitted = false.obs;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.dialog(
          barrierDismissible: false,
          const GetDialog(
            type: 'error',
            title: 'Login Failed',
            hasMessage: true,
            buttonNumber: 0,
            hasCustomWidget: false,
            withCloseButton: true,
            message: 'Error: Please enable apps location.',
          ),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
  }

  Future<Position> getUserLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
