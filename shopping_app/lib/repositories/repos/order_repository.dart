
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/order.dart';

import '../../models/cart.dart';
import '../interfaces/order_interface.dart';

class OrderRepository extends IOrderRepository{

  final CollectionReference orderCollection= FirebaseFirestore.instance.collection('orders');
  final CollectionReference productCollection= FirebaseFirestore.instance.collection('products');

  @override
  Future<MyOrder> getOrder(String id) async{
    DocumentSnapshot doc = await orderCollection.doc(id).get();
    List<CartItem> items = (doc['listProduct'] as List<dynamic>).map((e){
      return CartItem(id: e['id'], quantity: e['quantity']);
    } ).toList();
    return MyOrder(
      id: id,
      items: items,
      time: doc['time'].toDate()
    );
  }

  @override
  Future<List<MyOrder>> getAllOrders() async{
    List<MyOrder> orders = [];
    try{
      QuerySnapshot snapshot = await orderCollection.get();
      orders =  await Future.wait(snapshot.docs.map((e) => getOrder(e.id)).toList());
    }catch(e){
      print(e);
    }
    return orders;
  }

  @override
  Future<void> createOrder(List<CartItem> items) async{
    try{
      List<Map<String, dynamic>> cartItems = items.map((e){
        return {'id': e.id, 'quantity': e.quantity} ;
      }).toList();
      DocumentReference documentReference = orderCollection.doc();
      await documentReference.set({
        'id': documentReference.id,
        'listProduct': cartItems,
        'time': Timestamp.fromDate(DateTime.now())
      });

      for(var item in items){
        DocumentReference productRef = productCollection.doc(item.id);
        DocumentSnapshot doc = await productCollection.doc(item.id).get();
        await productRef.update({
          'quantity': doc['quantity'] - item.quantity
        });
      }

    }catch(e){
      print(e);
    }
  }

}