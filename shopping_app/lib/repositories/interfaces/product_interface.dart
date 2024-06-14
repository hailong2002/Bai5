import '../../models/product.dart';

abstract class IProductRepository{
  Future<List<Product>> getALlProducts();
  Future<Product> getProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(String id, Product product);
  Future<void> deleteProduct(String id);
}