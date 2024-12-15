import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/item.dart';
import '../mainscreen/order_details_screen.dart';


class OrderCardUiDesign extends StatelessWidget {

  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderId;
  final List<String>? separateQuantityList;

  OrderCardUiDesign({super.key,
  this.itemCount, this.data, this.orderId, this.separateQuantityList});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailsScreen(orderId: orderId,)));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
           itemCount: itemCount,
            itemBuilder: (context, index){
              Item model = Item.fromJson(data![index].data()! as Map<String, dynamic>);
              return placeOrderDesignWidget(model, context, separateQuantityList![index]);
            }
        ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(Item model, BuildContext context, String quantityNumber){
  return Container(
    width: MediaQuery.of(context).size.width,
    height:150,
    child: Row(
      children: [
        Image.network(model.itemImage!, width: 120,),
        const SizedBox(width: 10,),
        Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),

                //title of the item.currency, price
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(model.itemTitle!,
                    style: const  TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: "Acme"
                    ),)),


                    const SizedBox(
                      width: 10,
                    ),

                    const Text("Rs",
                    style: TextStyle(fontSize: 16, color: Colors.blue),)
                    ,
                    Text(
                      model.price.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    )

                  ],
                ),

                const SizedBox(height: 20,),

                Row(
                  children: [
                    const Text("x",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                    ),),
                    Expanded(child:
                    Text(quantityNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Acme"
                    ),))
                  ],
                )


              ],
            )
        )
      ],
    ),
  );
}