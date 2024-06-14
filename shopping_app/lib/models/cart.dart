class Cart{
  List<CartItem> cartItems= [];
  String id='';
  Cart({required this.id, required this.cartItems});
}

class CartItem{
  String id = '';
  int quantity = 0;
  CartItem({required this.id, required this.quantity});
}