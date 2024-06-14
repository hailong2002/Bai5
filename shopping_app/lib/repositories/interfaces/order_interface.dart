import 'package:shopping_app/models/order.dart';

import '../../models/cart.dart';

abstract class IOrderRepository{
  Future<List<MyOrder>> getAllOrders();
  Future<MyOrder> getOrder(String id);
  Future<void> createOrder(List<CartItem> items);
}