import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../global/global_var.dart';

class CommonViewModel{
  getCurrentLocation() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = cPosition;
    placeMark = await placemarkFromCoordinates (cPosition.latitude, cPosition.longitude);
    Placemark placeMarkVar = placeMark![0];

    fullAddress = "${placeMarkVar.subThoroughfare} ${placeMarkVar.thoroughfare}, ${placeMarkVar.subLocality} ${placeMarkVar.locality}, ${placeMarkVar.subAdministrativeArea} ${placeMarkVar.administrativeArea} ${placeMarkVar.postalCode}";
     return fullAddress;
  }
  showSnackBar(String message, BuildContext context){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  updateLocationInDatabase() async{
    String address = getCurrentLocation();
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "address": address,
      "latitude":position?.latitude,
      "longitude": position?.longitude,
    });
  }

  getRiderPreviousEarnings()  async {
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap){
          previousRiderEarnings = "";
          previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getSellerPreviousEarnings(String sellersUid) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellersUid)
        .get().then((snap){
      previousSellerEarnings = "";
      previousSellerEarnings = snap.data()!["earnings"].toString();
    });

  }

  getOrderTotalAmount(String orderId) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get().then((snap){
      orderTotalAmount = "";
      orderTotalAmount = snap.data()!["totalAmount"].toString();
    });
  }




}