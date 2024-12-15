import 'package:flutter/material.dart';
import 'package:riders_app/global/global_ins.dart';
import '../../model/address.dart';
import '../splashScreen/splash_screen.dart';

class ShipmentAddressUiDesign extends StatelessWidget {
  Address? model;

  String? orderStatus;
  String? orderId;
  String? sellersUid;
  String? orderByUser;

  ShipmentAddressUiDesign({super.key, this.model,
  this.orderStatus,
  this.orderId,
  this.sellersUid,
  this.orderByUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.all(10),
        child: Text(
          "Shipping Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),),

        const SizedBox( height: 6.0,),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5 ),
          width: MediaQuery.of(context).size.width,
          child:Table(
            children: [
              TableRow(
                children: [
                  const Text(
                      "Name ", style: TextStyle(color: Colors.white)
                  ),
                  Text(model!.name!)
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                        "Phone Number ", style: TextStyle(color: Colors.white)
                    ),
                    Text(model!.phoneNumber!)
                  ]
              ),
            ],
          ),
        ),



        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Address ${model!.fullAddress!}",
            textAlign: TextAlign.justify,
          ),
        ),

      orderByUser == "ended" ? Container() :
      Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () async {
            String completeAddress = await commonViewModel.getCurrentLocation();

            //confirm to deliver
           ordersViewModel.confirmToDeliver(orderId!, sellersUid!, orderByUser!, completeAddress, context, model!);
          },
          child: Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: const Center(
              child: Text("Confirm Pick",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ),


        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> mySplashScreen()));
              // Navigator.pop(context);
            },
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: const Center(
                child: Text("Go back",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ),


      ],
    );
  }
}
