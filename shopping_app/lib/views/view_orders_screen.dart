import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/order_viewmodel.dart';

import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ViewOrdersScreent extends StatefulWidget {
  const ViewOrdersScreent({Key? key}) : super(key: key);

  @override
  State<ViewOrdersScreent> createState() => _ViewOrdersScreentState();
}

class _ViewOrdersScreentState extends State<ViewOrdersScreent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
        backgroundColor: Colors.amber,
      ),
      body: Consumer<OrderViewModel>(
        builder: (BuildContext context, orderViewModel, _) {
          orderViewModel.getAllOrders();
          List<MyOrder>? orders = orderViewModel.orders;
          if(orders == null){
            return const Center(child: Text('There have no order'));
          }
          return orders.isEmpty ?  const Center(child: Text('There have no order')) :
          Container(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...orders[index].items.map((item) {
                          return Consumer<ProductViewModel>(
                            builder: (context, productViewModel, _) {
                              Product product = productViewModel.products!
                                  .where((p) => p.id == item.id)
                                  .first;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          product.image,
                                          height: 80,
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('${orders[index].time.day}/${orders[index].time.month}/${orders[index].time.year}'),
                                                const SizedBox(width: 20),
                                                Text('${orders[index].time.hour}:${orders[index].time.minute}'),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text( product.name, style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text('\$${product.price}',style:const TextStyle(fontSize: 18, color: Colors.orange)),
                                                const SizedBox(width: 30),
                                                Text('Quantity: ${item.quantity}',style:const TextStyle(fontSize: 18)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );

        },

      ),

    );
  }
}
