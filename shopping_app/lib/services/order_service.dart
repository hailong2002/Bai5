import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/order.dart';
import 'package:shopping_app/repositories/interfaces/order_service_interface.dart';

import '../models/cart.dart';
import '../repositories/interfaces/order_interface.dart';

class OrderService extends IOrderService{

  final IOrderRepository repository;

  OrderService(this.repository);

  @override
  Future<MyOrder> getOrder(String id) async {
    return await repository.getOrder(id);
  }


  @override
  Future<List<MyOrder>> getAllOrders() async{
    return await repository.getAllOrders();
  }

  @override
  Future<void> createOrder(List<CartItem> items) async{
    await repository.createOrder(items);
  }



}