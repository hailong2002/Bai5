import 'package:flutter/cupertino.dart';
import 'package:shopping_app/services/product_service.dart';

import '../models/product.dart';
import '../repositories/interfaces/product_service_interface.dart';

class ProductViewModel extends ChangeNotifier{

  final IProductService _service;
  List<Product>? products;
  Product? product;
  String? id;
  String name = 'name';
  String description ='description';
  double price = 0;
  int quantity = 0;
  String address ='address';
  String image = 'image';

  ProductViewModel(this._service);

  Future<void> getAllProduct() async{
    products = await _service.getALlProducts();
    notifyListeners();
  }

  Future<void> getProduct(String id) async{
    product = await _service.getProduct(id);
    notifyListeners();
  }

  Product getProductModel(String id, ProductViewModel productViewModel){
    return Product(
      id: id,
      name: productViewModel.name,
      description: productViewModel.description,
      price: productViewModel.price,
      quantity: productViewModel.quantity,
      image: productViewModel.image,
      address: productViewModel.address,
    );
  }

  Future<void> createProduct(ProductViewModel productViewModel) async{
    Product product = getProductModel('', productViewModel);
    await _service.createProduct(product);
    products!.add(product);
    getAllProduct();
  }

  Future<void> updateProduct(String id, ProductViewModel productViewModel) async{
    Product product = getProductModel(id, productViewModel);
    await _service.updateProduct(id, product);

    Product p = products!.where((e) => e.id == id).first;
    products![products!.indexOf(p)] = product;
    getAllProduct();
  }

  Future<void> deleteProduct(String id) async{
    await _service.deleteProduct(id);
    Product p = products!.where((e) => e.id == id).first;
    products!.remove(p);
    getAllProduct();
  }




}