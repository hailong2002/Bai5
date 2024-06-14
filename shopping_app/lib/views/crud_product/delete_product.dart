import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';
import 'package:shopping_app/views/home_screen.dart';

class DeleteProductWidget extends StatelessWidget {
  const DeleteProductWidget({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context) {
    ProductViewModel productViewModel = Provider.of<ProductViewModel>(context);
    return AlertDialog(
      title: const Text('Confirm delete', style: TextStyle(color: Colors.redAccent, fontSize: 20),),
      content:Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure want to delete?'),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        productViewModel.deleteProduct(id);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomeScreent()),
                                (route) => false);
                        },
                        child: const
                      Text('Delete')
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      onPressed: ()=> Navigator.pop(context),
                      child: const Text('Cancel')
                  ),
                ],
              )
          ],
        ),
      ),

    );

  }
}
