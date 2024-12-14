import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Position? position;
List<Placemark>? placeMark;
String fullAddress = "";
SharedPreferences? sharedPreferences;
String previousRiderEarnings ="";
String previousSellerEarnings="";
String orderTotalAmount = "";
String amountChargedForDelivery = "50";