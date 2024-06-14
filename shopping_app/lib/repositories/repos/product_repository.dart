import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/interfaces/product_interface.dart';

class ProductRepository extends IProductRepository{

  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  @override
  Future<Product> getProduct(String id) async {
    DocumentSnapshot doc = await productCollection.doc(id).get();
    Product product = Product(
        id: id,
        name: doc['name'],
        description: doc['description'],
        price: doc['price'],
        quantity: doc['quantity'],
        address: doc['address'],
        image: doc['image']
    );
    return product;
  }

  @override
  Future<List<Product>> getALlProducts() async {
    List<Product> products = [];
    try{
      QuerySnapshot snapshot = await productCollection.get();
      products = await Future.wait(snapshot.docs.map((e) => getProduct(e.id)).toList()) ;
    }catch(e){
      print(e);
    }
    return products;

  }

  @override
  Future<void> createProduct(Product product) async{
    try{
      DocumentReference documentReference = productCollection.doc();
      await documentReference.set({
        'id': documentReference.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'quantity': product.quantity,
        'address': product.address,
        'image': product.image,
      });

    }catch(e){
      print(e);
    }
  }

  @override
  Future<void> deleteProduct(String id) async{
    try{
      if(id.isNotEmpty){
        await productCollection.doc(id).delete();
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Future<void> updateProduct(String id, Product product) async {
    try{
      if(id.isNotEmpty){
        await productCollection.doc(id).update({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'quantity': product.quantity,
          'address': product.address,
          'image': product.image,
        });
      }
    }catch(e){
      print(e);
    }
  }
  
}