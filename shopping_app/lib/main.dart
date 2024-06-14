import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/repositories/interfaces/cart_interface.dart';
import 'package:shopping_app/repositories/interfaces/cart_service_interface.dart';
import 'package:shopping_app/repositories/interfaces/order_interface.dart';
import 'package:shopping_app/repositories/interfaces/order_service_interface.dart';
import 'package:shopping_app/repositories/interfaces/product_interface.dart';
import 'package:shopping_app/repositories/interfaces/product_service_interface.dart';
import 'package:shopping_app/repositories/repos/cart_repository.dart';
import 'package:shopping_app/repositories/repos/order_repository.dart';
import 'package:shopping_app/repositories/repos/product_repository.dart';
import 'package:shopping_app/services/cart_service.dart';
import 'package:shopping_app/services/order_service.dart';
import 'package:shopping_app/services/product_service.dart';
import 'package:shopping_app/viewmodels/cart_viewmodel.dart';
import 'package:shopping_app/viewmodels/order_viewmodel.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';
import 'package:shopping_app/views/home_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
          providers: [
            Provider<IProductRepository>(
              create: (_) => ProductRepository(),
            ),
            Provider<IProductService>(
              create: (context) => ProductService(
              Provider.of<IProductRepository>(context, listen: false),
              ),
            ),
            ChangeNotifierProvider<ProductViewModel>(
              create: (context)=> ProductViewModel(
              Provider.of<IProductService>(context, listen: false)
                ),
            ),

            Provider<ICartRepository>(
              create: (_) => CartRepository(),
            ),
            Provider<ICartService>(
              create: (context) => CartService(
                Provider.of<ICartRepository>(context, listen: false),
              ),
            ),
            ChangeNotifierProvider<CartViewModel>(
              create: (context) => CartViewModel(
                Provider.of<ICartService>(context, listen: false)
              ),
            ),

            Provider<IOrderRepository>(
              create: (_) => OrderRepository(),
            ),
            Provider<IOrderService>(
              create: (context) => OrderService(
                Provider.of<IOrderRepository>(context, listen: false),
              ),
            ),
            ChangeNotifierProvider<OrderViewModel>(
              create: (context) => OrderViewModel(
                  Provider.of<IOrderService>(context, listen: false)
              ),
            ),

          ],
        child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: const HomeScreent(),
    );
  }
}
