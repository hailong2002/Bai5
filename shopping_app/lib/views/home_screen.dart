import 'package:flutter/material.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';
import 'package:shopping_app/views/crud_product/product_details.dart';
import 'package:shopping_app/views/shopping_cart_screen.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import 'account_screen.dart';

class HomeScreent extends StatefulWidget {
  const HomeScreent({Key? key}) : super(key: key);

  @override
  State<HomeScreent> createState() => _HomeScreentState();
}

class _HomeScreentState extends State<HomeScreent> {

  int _selectedIndex = 0;
  TextEditingController textController = TextEditingController();

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreent(),
    ShoppingCartScreent(),
    AccountScreent()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? Consumer<ProductViewModel>(
        builder: (context, productViewModel, _) {
            List<Product> products = productViewModel.products ?? [];
            if (products.isEmpty) {
              productViewModel.getAllProduct();
              return const Center(child: Text('There have nothing'));
            }
            else {
              return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10 ),
                      child: Column(
                        children: [
                          productViewModel.products!.isEmpty ?  const Center(child: CircularProgressIndicator())  :
                          Expanded(
                            child: GridView.builder(
                                gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 200
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index){
                                  Product product = products[index];
                                  return products.isEmpty ? const Center(child: Text('There have nothings')) :
                                     InkWell(
                                       onTap: (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailsScreent(id: products[index].id)));
                                       },
                                       child: Card(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.network(product.image, height: 120, width: 200, fit: BoxFit.cover),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                                                    const SizedBox(height: 5),
                                                    product.quantity > 0 ? Text('\$ ${product.price}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)) :
                                                    Text('\$ ${product.price} out of stock',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange, decoration: TextDecoration.lineThrough,)),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.location_on, color: Colors.grey, size: 14,),
                                                        Text(product.address, style: const TextStyle(color: Colors.grey))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )

                                          ],
                                        ),

                                    ),
                                     );
                                }
                            ),
                          )
                        ],
                      ),
                    ),
      );
            } }) :
      _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home' ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: 'Cart' ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp), label: 'Account' ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
