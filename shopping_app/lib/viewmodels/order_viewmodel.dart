import 'package:flutter/cupertino.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/viewmodels/cart_viewmodel.dart';

import '../models/order.dart';
import '../repositories/interfaces/order_service_interface.dart';

class OrderViewModel extends ChangeNotifier{
  String id = '';
  List<CartItem> items = [];
  DateTime time = DateTime.now();

  List<MyOrder>? orders;
  MyOrder? order;

  IOrderService service;

  OrderViewModel(this.service);

  MyOrder getOrderFromViewModel(OrderViewModel orderViewModel) {
    return MyOrder(
        id: orderViewModel.id,
        items: orderViewModel.items,
        time: orderViewModel.time
    );
  }

  Future<void> getAllOrders() async{
     orders = await service.getAllOrders();
     notifyListeners();
  }

  Future<void> getOrder(String id) async{
    order = await service.getOrder(id);
    notifyListeners();
  }

  Future<void> createOrder(List<CartItemViewModel> items) async{
    List<CartItem> cartItems = items.map((e){
      return CartItem(id: e.id, quantity: e.quantity);
    }).toList();
    await service.createOrder(cartItems);
    notifyListeners();
  }

}