import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF3E1EFF);
const Color navBlue = Color(0xFF274D85);
const Color bgPrimaryBlue = Color(0xFF1F4583);
const Color bgSecondaryBlue = Color(0xFF2465C7);
const Color skyBlue = Color(0xFF17C1CC);
const Color lightGray = Color(0xFFECEAEA);
const Color darkGray = Color(0xFF404040);
const Color gray = Color(0xFF888888);
const Color orange = Color(0xFFF9A425);

const Color textMuted = Color(0xFF8F8F90);
const Color textBlack = Color(0xFF444444);

const Color colorQuestion = Color(0xFF3066BE);
const Color colorError = Color(0xFFCB1212);
const Color colorSuccess = Color.fromARGB(255, 86, 162, 107);
const Color colorNoRecord = Color(0xFFC2C2C2);

const Color yellow = Color(0xFFFFC700);
const Color primaryRed = Color(0xFFFF1F1E);
const Color lightRed = Color.fromARGB(255, 251, 95, 95);

const String googleApiKey = 'AIzaSyDqLokxh3yyUWma5i0obuZgEuhgbeTx-i8';
const String fireStoreDoc = 'staging';
// const String fireStoreDoc = 'production';

const List mapStyleNoLandmarks = [
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {"visibility": "off"}
    ]
  }
];
