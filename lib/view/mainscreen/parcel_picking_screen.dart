import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/global/global_ins.dart';
import 'package:riders_app/global/global_var.dart';


class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLong;

  ParcelPickingScreen({super.key,
  this.purchaserId,
  this.sellerId,
  this.getOrderId,
  this.purchaserAddress,
  this.purchaserLat,
  this.purchaserLong});

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
 double? sellerLat, sellerLong;
  getSellerInfo() async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get().then((snapshot){
          sellerLat = snapshot.data()!["latitude"];
          sellerLong = snapshot.data()!["longitude"];
    });
  }

  @override
  void initState() {
    super.initState();
    getSellerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),

          const SizedBox(height: 5,),
          GestureDetector(
            onTap:() {

            ordersViewModel.launchMapFromDestinationToDestination(
                position!.latitude, position!.longitude, sellerLat, sellerLong);


            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/restaurant.png',
                width: 50,),

                const SizedBox(width:7),

                const Text(
                  "Show cafe/ Restaurant Location",
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 40,),

          Padding(padding: const EdgeInsets.all(10),child: Center(
            child: InkWell(
              onTap: () async {

                String completeAddress = await commonViewModel.getCurrentLocation();

                ordersViewModel.confirmParcelHasBeenPicked(
                  widget.getOrderId,
                  widget.sellerId,
                  widget.purchaserId,
                  widget.purchaserAddress,
                  widget.purchaserLat,
                  widget.purchaserLong,
                  completeAddress,
                  context
                );

              },
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: const Center(
                  child: Text(
                    "Order has been Picked - Confirmed",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),)
        ],
      ),
    );
  }
}
