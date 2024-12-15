import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/view/mainscreen/parcel_delivering_screen.dart';
import 'package:riders_app/view/mainscreen/parcel_picking_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global/global_var.dart';
import '../model/address.dart';




class OrdersViewModel{

  saveOrderDetailsToDatabase(addressId, totalAmount, sellersUid,orderId){

    writeOrderDetailsForUser({
      "addressId": addressId,
      "totalAmount": totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIds": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Online Payment",
      "orderTime": orderId,
      "isSuccess":true,
      "sellersUid": sellersUid,
      "ridersUid":"",
      "status": "normal",
      "orderId": orderId,
    });


    writeOrderDetailsForSeller({
      "addressId": addressId,
      "totalAmount": totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIds": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Online Payment",
      "orderTime": orderId,
      "isSuccess":true,
      "sellersUid": sellersUid,
      "ridersUid":"",
      "status": "normal",
      "orderId": orderId,
    });


  }


  writeOrderDetailsForUser(Map<String, dynamic> dataMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(dataMap["orderId"])
        .set(dataMap);
  }


  writeOrderDetailsForSeller(Map<String, dynamic> dataMap) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(dataMap["orderId"])
        .set(dataMap);
  }

  retrieveOrder(){
    return FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "normal")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }


  separateItemIdsForOrders(orderIds){

    List<String> separateItemIDsList = [], defaultItemList = [];
    int i = 0;

    defaultItemList = List<String>.from(orderIds);

    for(i;i<defaultItemList.length;i++){
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");


      String getItemId = (pos != -1) ? item.substring(0,pos) : item;
      separateItemIDsList.add(getItemId);
    }

    return separateItemIDsList;

  }

  separateOrderItemQuantity(orderIds){
    List<String> separateItemQuantityList = [], defaultItemList = [];
    int i = 1;

    defaultItemList =List<String>.from(orderIds);

    for(i;i<defaultItemList.length;i++){
      String item = defaultItemList[i].toString();
      List<String> listItemCharacters = item.split(":").toList();

      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber.toString());

    }
    return separateItemQuantityList;
  }


  getSpecificOrderDetails(String orderId){

   return  FirebaseFirestore.instance
       .collection("orders")
       .doc(orderId)
       .get();

  }

  getShipmentAddress(String addressId, String orderByUserId){

    return  FirebaseFirestore.instance
        .collection("users")
        .doc(orderByUserId)
        .collection("userAddress")
        .doc(addressId)
        .get();

  }


   confirmToDeliver(orderId, sellersUid, orderByUser, completeAddress,context, Address model){
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .update({

      "ridersUid": sharedPreferences!.getString("uid"),
      "riderName": sharedPreferences!.getString("name"),
      "status":"picking",
      "lat":position!.latitude,
      "long": position!.longitude,
      "address":completeAddress
    }).then((value){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelPickingScreen(
        purchaserId:orderByUser,
        purchaserAddress: model.fullAddress,
        purchaserLat: model.lat,
        purchaserLong: model.long,
        sellerId: sellersUid,
        getOrderId: orderId,
      )));
    });
   }

   confirmParcelHasBeenPicked(getOrderId, sellerId, purchaserId, purchaserAddress, purchaserLat, purchaseLong, completeAddress,context) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId).update({
        "status": "delivering",
      "address": completeAddress,
      "lat":position!.latitude,
      "long":position!.longitude,
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelDeliveringScreen(
      purchaserId: purchaserId,
      purchaserAddress: purchaserAddress,
      purchaserLat: purchaserLat,
      purchaserLong: purchaseLong,
      sellerId: sellerId,
      getOrderId: getOrderId,
    )));
   }

   confirmParcelHasBeenDelivered(getOrderId, sellerId, purchaserId, purchaserAddress, purchaserLat, purchaserLong, completeAddress) async {
    String totalRidersEarnings = ((double.parse(previousRiderEarnings)) + (double.parse(amountChargedForDelivery))).toString();
    String totalSellersEarnings = ((double.parse(previousSellerEarnings)) + (double.parse(orderTotalAmount))).toString();

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId)
        .update({
        'status':'ended',
      'address': purchaserAddress,
      'lat':position!.latitude,
      'long': position!.longitude,
      "deliveryCharge":amountChargedForDelivery,
    }).then((value) async {
   await FirebaseFirestore.instance
      .collection("riders")
      .doc(sharedPreferences!.getString("uid")).update({
      "earnings": totalRidersEarnings
  }).then((value) async {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(sellerId).update({
      "earnings":totalSellersEarnings
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(purchaserId)
          .collection("orders")
          .doc(getOrderId).update({
        "status": "ended",
        "ridersUid": sharedPreferences!.getString("uid")
      });
    });
   });
    });

   }


   launchMapFromDestinationToDestination(sourceLat, sourceLong, destinationLat, destinationLong) async {

    String mapOptions =
        [
          'saddr=$sourceLat,$sourceLong',
          'daddr=$destinationLat,$destinationLong'
          'dir_action=navigate'
        ].join('&');

    final googleMapUrl = 'https://www.google.com/maps?$mapOptions';
    if(await launchUrl(Uri.parse(googleMapUrl))){
      await launchUrl(Uri.parse(googleMapUrl));
    }else{
      throw "Something went wrong try again!";
    }

   }


  retrieveInProgressOrder(){
    return FirebaseFirestore.instance
        .collection("orders")
    .where("ridersUid",isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "picking")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

  retrieveToBeDeliveredOrder(){
    return FirebaseFirestore.instance
        .collection("orders")
        .where("ridersUid",isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "delivering")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

  retrieveOrderHistory(){
    return FirebaseFirestore.instance
        .collection("orders")
        .where("ridersUid",isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "ended")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }





}