import '../../models/cart.dart';

abstract class ICartService{
  Future<List<String>> getProductInCart();
  Future<void> addProductToCart(CartItem item);
  Future<void> removeProductFormCart(String productId);
  Future<Cart> getCart();
}