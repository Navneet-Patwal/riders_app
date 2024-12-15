import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global_ins.dart';
import '../widgets/my_appbar.dart';
import '../widgets/order_card_ui_design.dart';


class NotYetDeliveredScreen extends StatefulWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  State<NotYetDeliveredScreen> createState() => _NotYetDeliveredScreenState();
}

class _NotYetDeliveredScreenState extends State<NotYetDeliveredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "To Be Delivered", showBackButton: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersViewModel.retrieveToBeDeliveredOrder(),
        builder: (c, snapshot){
          return snapshot.hasData ?
          ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c,index){
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("items")
                      .where("itemId", whereIn: ordersViewModel.separateItemIdsForOrders(
                      (snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIds"]
                  ))
                      .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDateTime", descending: true)
                      .get(),
                  builder: (c, snap){
                    return snap.hasData ? Card(
                      child: OrderCardUiDesign(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderId: snapshot.data!.docs[index].id,
                          separateQuantityList: ordersViewModel.separateOrderItemQuantity((snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIds"])),
                    ) : const Center(child: CircularProgressIndicator(color: Colors.green,),);
                  },

                );
              }
          ):
          //Center(child: Text("No orders found", style: TextStyle(color: Colors.white),),);
          const Center(child: CircularProgressIndicator(color: Colors.green,),);

        },
      ),
    );
  }
}
