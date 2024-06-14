import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';

import '../../models/product.dart';

class ViewAllProductsScreent extends StatefulWidget {
  const ViewAllProductsScreent({Key? key}) : super(key: key);

  @override
  State<ViewAllProductsScreent> createState() => _ViewAllProductsScreentState();
}

class _ViewAllProductsScreentState extends State<ViewAllProductsScreent> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View all products'),
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, Widget? child) {
          List<Product> products = productViewModel.products ?? [];
          if (products.isEmpty) {
            productViewModel.getAllProduct();
            return const Center(child: Text('There have nothing'));
          }
          return Container(
            child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  Product product = products[index];
                  return ListTile(
                    leading: Text('${index+1}.'),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}, quantity: ${product.quantity}'),
                    trailing: Image.network(product.image, height: 100, fit: BoxFit.cover),
                  );
                }
            ),
          );
        },

      ),
    );
  }
}
