import 'package:flutter/material.dart';
import 'package:shopping_app/views/crud_product/create_product.dart';
import 'package:shopping_app/views/view_orders_screen.dart';

class AccountScreent extends StatefulWidget {
  const AccountScreent({Key? key}) : super(key: key);

  @override
  State<AccountScreent> createState() => _AccountScreentState();
}

class _AccountScreentState extends State<AccountScreent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.withOpacity(0.3),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
          child: Column(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15)
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const CreateProductScreent(id: '')));
                    },
                    child: const Text('Create product'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15)
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ViewOrdersScreent()));
                    },
                    child: const Text('View orders')
                ),
                const SizedBox(width: 15),
              ],

        ),
      ),
    );
  }
}
