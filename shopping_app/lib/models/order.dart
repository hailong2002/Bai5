import 'cart.dart';

class MyOrder{
  String id;
  List<CartItem> items;
  DateTime time;

  MyOrder({required this.id, required this.items, required this.time});
}