import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../global/global_ins.dart';
import '../../model/address.dart';
import '../widgets/shipment_address_ui_design.dart';
import '../widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  String? orderId;
  OrderDetailsScreen({super.key, this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  String? orderStatus ="";
  String orderByUser = "";
  String sellersUid="";

  getOrderInfo(){
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get().then((snapshot){
          orderStatus = snapshot.data()!["status"].toString();
          orderByUser = snapshot.data()!["orderBy"].toString();
          sellersUid = snapshot.data()!["sellersUid"].toString();

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top:50),
        child: FutureBuilder<DocumentSnapshot>(
            future: ordersViewModel.getSpecificOrderDetails(widget.orderId.toString()),
            builder: (c, snapshot){
              Map? dataMap;

              if(snapshot.hasData){
                dataMap = snapshot.data!.data() as Map<String, dynamic>;
                orderStatus = dataMap["status"].toString();
              }

              return snapshot.hasData ?
              Column(
                children: [
                  StatusBanner(
                    status: dataMap!["isSuccess"],orderStatus: orderStatus,
                  ),

                  const SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(" Total Amount: Rs ${dataMap["totalAmount"]}",
                        style: const  TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Order Id: " + widget.orderId!,
                      style: const TextStyle(fontSize: 16),
                    ),),


                  Padding(padding: const EdgeInsets.all(8),
                    child: Text(
                      "Order at: ${DateFormat('dd MMMM, yyyy - hh:mm aa')
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),),

                  const Divider(thickness: 6,),

                  orderStatus == "ended" ?
                  Image.asset("images/success.jpg"):
                  Image.asset("images/confirm_pick.png"),


                  const Divider(thickness: 4,),

                  FutureBuilder<DocumentSnapshot>(
                      future: ordersViewModel.getShipmentAddress(dataMap["addressId"],dataMap["orderBy"]),
                      builder: (c, snapshotAddress){
                        return snapshotAddress.hasData?
                        ShipmentAddressUiDesign(
                          model: Address.fromJson(
                              snapshotAddress.data!.data() as Map<String, dynamic>
                          ),
                          orderStatus:orderStatus,
                          orderId: widget.orderId,
                          sellersUid: sellersUid,
                          orderByUser: orderByUser
                        ):
                        const Center(child: CircularProgressIndicator(color:Colors.green),);
                      }
                  )
                ],
              )
                  :
              const Center(child: CircularProgressIndicator(color: Colors.green,),);
            }
        ),
      ),
    );
  }
}
