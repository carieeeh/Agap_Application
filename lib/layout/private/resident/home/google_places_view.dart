import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class GooglePlacesView extends StatelessWidget {
  GooglePlacesView({super.key});

  final TextEditingController _autoCompleteController = TextEditingController();
  final LocationsController _locController = Get.find<LocationsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _autoCompleteController,
                  googleAPIKey: googleApiKey,
                  inputDecoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search a location...",
                  ),
                  countries: const ["ph"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    _locController.isLoading.value = false;

                    Get.back(result: {
                      'description': prediction.description ?? "",
                      'lat': prediction.lat ?? "",
                      'lng': prediction.lng ?? "",
                    });
                  },
                  itemClick: (Prediction prediction) {
                    _autoCompleteController.text = prediction.description ?? "";
                    _autoCompleteController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description!.length));
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 7),
                              Expanded(
                                  child: Text(prediction.description ?? ""))
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  seperatedBuilder: Divider(),
                  isCrossBtnShown: true,
                  containerHorizontalPadding: 10,
                ),
                InkWell(
                  onTap: () {
                    _locController.isLoading.value = false;

                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.my_location),
                        SizedBox(width: 7),
                        Expanded(child: Text("Select current location"))
                      ],
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
