import 'package:flutter/material.dart';
import 'package:riders_app/global/global_var.dart';
import 'package:riders_app/view/splashScreen/splash_screen.dart';

import '../../global/global_ins.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLong;

  ParcelDeliveringScreen({super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLong});

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {

  getUpdatedInfo() async {
    await commonViewModel.getRiderPreviousEarnings();
    await commonViewModel.getSellerPreviousEarnings(widget.sellerId!.toString());
    await commonViewModel.getOrderTotalAmount(widget.getOrderId!.toString());
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpdatedInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm2.png",
          ),

          const SizedBox(height:5),

          GestureDetector(
            onTap:() {

            //show location towards to user location
              ordersViewModel.launchMapFromDestinationToDestination(
                  position!.latitude,
                  position!.longitude,
                  widget.purchaserLat,
                  widget.purchaserLong
              );

            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/restaurant.png',
                  width: 50,),

                const SizedBox(width:7),

                const Text(
                  "Show delivery Drop-off Location",
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
                //confirm order delivered
                await ordersViewModel.confirmParcelHasBeenDelivered(
                  widget.getOrderId,
                  widget.sellerId,
                  widget.purchaserId,
                  widget.purchaserAddress,
                  widget.purchaserLat,
                  widget.purchaserLong,
                  completeAddress,
                );

                commonViewModel.showSnackBar("Order Status Updated to ended Successfully.", context);
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const mySplashScreen()));


              },
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: const Center(
                  child: Text(
                    "Order has been Delivered - Confirm",
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
