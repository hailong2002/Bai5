import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/order_viewmodel.dart';
import 'package:shopping_app/views/widgets/product_cartitem.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';

class ShoppingCartScreent extends StatefulWidget {
  const ShoppingCartScreent({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreent> createState() => _ShoppingCartScreentState();
}

class _ShoppingCartScreentState extends State<ShoppingCartScreent> {

  double totalPrice = 0;
  List<CartItemViewModel> items= [];

  void handleCheckboxValueChanged(double value, CartItemViewModel item, bool isChecked) {
    setState(() {
      if(isChecked){
        totalPrice += value;
        items.add(item);
      }else{
        totalPrice -= value;
        items.remove(items.where((e) =>e.id == item.id).first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderViewModel order = Provider.of<OrderViewModel>(context);
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, _) {
        cartViewModel.getCart();
        Cart? cart = cartViewModel.cart;
        return
        cart == null ? const Center(child: CircularProgressIndicator()) :
        Scaffold(
          appBar: AppBar(
            title: const Text('My cart'),
            backgroundColor: Colors.amber,
          ),
          body: Container(
            color: Colors.grey.withOpacity(0.3),
            child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index){
                    CartItem item = cart.cartItems[index];
                    return Consumer<ProductViewModel>(
                        builder: (context, productViewModel, _){
                          Product product = productViewModel.products!.where((p) => p.id == item.id).first;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ProductCartItem(
                              id: product.id,
                              quantity: item.quantity,
                              maxQuantity: product.quantity,
                              price: product.price,
                              name: product.name,
                              image: product.image,
                              onChanged: (value, cartItem, bool isChecked){
                                handleCheckboxValueChanged(value,cartItem, isChecked);
                              }
                            )
                          );
                        }
                    );
                }
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Total price: \$ ${double.parse((totalPrice).toStringAsFixed(2))}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    order.createOrder(items);
                  },
                  child: const Text('Order Now', style: TextStyle(color: Colors.orange,fontSize: 18),),
                ),
              ],
            ),
          ),

        );
      },

    );
  }
}





