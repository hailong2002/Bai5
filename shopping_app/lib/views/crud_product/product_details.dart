import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/repositories/interfaces/order_interface.dart';
import 'package:shopping_app/repositories/interfaces/order_service_interface.dart';
import 'package:shopping_app/viewmodels/cart_viewmodel.dart';
import 'package:shopping_app/viewmodels/order_viewmodel.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';
import 'package:shopping_app/views/crud_product/create_product.dart';
import 'package:shopping_app/views/widgets/snackbar_widget.dart';

import '../../models/product.dart';
import '../shopping_cart_screen.dart';
import 'delete_product.dart';

class ProductDetailsScreent extends StatefulWidget {
  const ProductDetailsScreent({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<ProductDetailsScreent> createState() => _ProductDetailsScreentState();
}

class _ProductDetailsScreentState extends State<ProductDetailsScreent> {
  int selectQuantity = 1;
  @override
  Widget build(BuildContext context) {
    CartViewModel cartViewModel = Provider.of<CartViewModel>(context);
    OrderViewModel orderViewModel = Provider.of<OrderViewModel>(context);
    return Consumer<ProductViewModel>(
      builder: (context, productViewModel, _) {
        Product? product = productViewModel.products!.where((p) =>p.id == widget.id).first;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text('Product Details'),
            actions: [
              IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShoppingCartScreent()));
              },
                  icon: const Icon(Icons.shopping_cart)),
              IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateProductScreent(id: widget.id)));
                },
                  icon: const Icon(Icons.edit_outlined)),
              IconButton(onPressed: (){
                showDialog(context: context,
                    builder: (context){
                  return DeleteProductWidget(id: widget.id);
                });
              }, icon: const Icon(Icons.delete)),
            ],
          ),
          body: Container(
            child:  SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(product.image, height: 300, width: 400, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                          const SizedBox(height: 10),
                          Text('Price: \$${product.price}',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent)),
                          const SizedBox(height: 10),
                          product.quantity > 0 ? Text('Quantity remaining: ${product.quantity}',style: const TextStyle(fontSize: 20)) :
                          const Text('Out of stock',style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.4)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const  [
                                    Icon(Icons.done_outline, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text('Allowed to change   -   '),
                                    Text('Free returns in 30 days'),
                                  ],
                                ),
                                Row(
                                  children: const  [
                                    Icon(Icons.delivery_dining, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text('Guaranteed delivery within 2-3 days '),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Store's address: ${product.address}",style: const TextStyle(fontSize: 17)),
                          const SizedBox(height: 10),
                          Text("Description: ${product.description}", style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 1,),
                    product.quantity > 0 ?
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              if(selectQuantity > 1){
                                setState(()=> selectQuantity-=1);
                              }
                            },
                            icon: const Icon(Icons.remove)
                        ),
                        Text('$selectQuantity'),
                        IconButton(
                            onPressed: (){
                              if(selectQuantity < product.quantity){
                                setState(()=> selectQuantity+=1);
                              }
                            },
                            icon: const Icon(Icons.add)
                        )
                      ],
                    ) : const SizedBox(),
                    product.quantity > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                              ),
                              onPressed: (){
                                CartItemViewModel item = CartItemViewModel(
                                  id: widget.id, quantity:  selectQuantity
                                );
                                cartViewModel.addProductToCart(item);
                                showSnackBar(context, "Product's added to cart", Colors.blue);
                              },
                              child: Row(
                                children: const [
                                  Text('Add to cart ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  Icon(Icons.add_shopping_cart_sharp)
                                ],
                              )
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                              ),
                              onPressed: (){
                                List<CartItemViewModel> items = [];
                                CartItemViewModel item = CartItemViewModel(
                                    id: widget.id, quantity:  selectQuantity
                                );
                                items.add(item);
                                orderViewModel.createOrder(items);
                                showSnackBar(context, "Product's ordered successful", Colors.greenAccent);
                              },
                              child: Row(
                                children:const [
                                  Text('Buy now', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  Icon(Icons.attach_money_sharp)
                                ],
                              )
                          ),
                        ],
                      ),
                    ) : const SizedBox(),

                  ],
                ),
            ),
            ),
        );
      },
    );
  }

}
