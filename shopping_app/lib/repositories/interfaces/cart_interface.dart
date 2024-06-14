import '../../models/cart.dart';
import '../../models/product.dart';

abstract class ICartRepository{
  Future<List<String>> getProductsInCart();
  Future<void> addProductToCart(CartItem item);
  Future<void> removeProductFromCart(String productId);
  Future<Cart> getCart();
}