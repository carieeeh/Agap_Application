import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

class LocationsController extends GetxController {
  RxBool isPermitted = false.obs, isLoading = false.obs;

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
    isLoading.value = true;
    final position = await Geolocator.getCurrentPosition();
    isLoading.value = false;
    return position;
  }

  Future<String> getAddressByCoordinates(Position position) async {
    isLoading.value = true;
    final api = GoogleGeocodingApi(googleApiKey, isLogged: true);
    final reversedSearchResults = await api.reverse(
      '${position.latitude}, ${position.longitude}',
      language: 'en',
    );
    isLoading.value = false;

    return reversedSearchResults.results.firstOrNull?.formattedAddress ?? "";
  }
}
