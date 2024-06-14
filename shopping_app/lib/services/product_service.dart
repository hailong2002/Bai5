import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/repos/product_repository.dart';

import '../repositories/interfaces/product_interface.dart';
import '../repositories/interfaces/product_service_interface.dart';

class ProductService extends IProductService{
  final IProductRepository productRepository;
  ProductService(this.productRepository);

  @override
  Future<Product> getProduct(String id) async{
     return await productRepository.getProduct(id);
  }

  @override
  Future<List<Product>> getALlProducts() async{
    return await productRepository.getALlProducts();
  }

  @override
  Future<void> createProduct(Product product) async{
    await productRepository.createProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) async{
    await productRepository.deleteProduct(id);
  }

  @override
  Future<void> updateProduct(String id, Product product) async {
    await productRepository.updateProduct(id, product);
  }

}