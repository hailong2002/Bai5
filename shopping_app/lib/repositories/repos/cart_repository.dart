import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/interfaces/cart_interface.dart';

class CartRepository extends ICartRepository{

  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');

  @override
  Future<List<String>> getProductsInCart() async{
    List<String> listProductId = [];
    try{
        DocumentSnapshot doc = await cartCollection.doc().get();
        listProductId = doc['listProduct'];
    }catch(e){
      print(e);
    }
    return listProductId;
  }

  @override
  Future<void> addProductToCart(CartItem item) async {
    Map<String, dynamic> cartItem = {'id': item.id, 'quantity': item.quantity};
    Cart cart = await getCart();
    try{
      DocumentReference documentReference;
      if(cart.id.isNotEmpty){
        documentReference = cartCollection.doc(cart.id);
      }else{
        documentReference = cartCollection.doc();
      }
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if(documentSnapshot.exists){
          List<dynamic> listProduct = documentSnapshot['listProduct'];
          int index = listProduct.indexWhere((e) => e['id'] == item.id);
          if (index >= 0) {
            listProduct[index]['quantity'] += item.quantity;
          } else {
            listProduct.add(cartItem);
          }
          documentReference.update({
            'id': documentReference.id,
            'listProduct': listProduct
          });
      }else{
        documentReference.set({
          'id': documentReference.id,
          'listProduct': [cartItem]
        });
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Future<void> removeProductFromCart(String productId) async{
    try{
      DocumentReference documentReference = cartCollection.doc();
      documentReference.update({
        'listProduct': FieldValue.arrayRemove([productId])
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Future<Cart> getCart() async {
    QuerySnapshot snapshot = await cartCollection.get();
    if (snapshot.docs.isEmpty) {
      return Cart(id: '', cartItems: []);
    }
    DocumentSnapshot doc = snapshot.docs[0];
    List<CartItem> items = (doc['listProduct'] as List<dynamic>).map((e){
      return CartItem(id: e['id'], quantity: e['quantity']);
    }).toList();
    return Cart(
        id: doc['id'],
        cartItems: items
    );
  }





}