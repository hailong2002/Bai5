import '../../models/cart.dart';
import '../../models/order.dart';

abstract class IOrderService{
  Future<List<MyOrder>> getAllOrders();
  Future<MyOrder> getOrder(String id);
  Future<void> createOrder(List<CartItem> items);
}