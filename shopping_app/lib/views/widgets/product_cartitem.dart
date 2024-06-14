import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/cart_viewmodel.dart';

class ProductCartItem extends StatefulWidget {
  const ProductCartItem({Key? key,
    required this.quantity,
    required this.price,
    required this.onChanged,
    required this.id,
    required this.image,
    required this.name, required this.maxQuantity}) : super(key: key);

  final int quantity;
  final int maxQuantity;
  final double price;
  final String id;
  final String image;
  final String name;
  final void Function(double value,CartItemViewModel item, bool isChecked) onChanged;

  @override
  State<ProductCartItem> createState() => _ProductCartItemState();
}

class _ProductCartItemState extends State<ProductCartItem> {
  bool isChecked = false;
  int selectedQuantity = 0;
  double price = 0;

  @override
  void initState(){
    super.initState();
    setState(()=> selectedQuantity = widget.quantity);
  }

  void _handleCheckboxChange(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
    double result = selectedQuantity * widget.price;
    CartItemViewModel cartItem = CartItemViewModel(id: widget.id, quantity: widget.quantity);
    if (value != null && value) {
      widget.onChanged(result, cartItem, true);
    } else {
      widget.onChanged(result, cartItem, false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
          Checkbox(
              value: isChecked,
              onChanged: (value){
                _handleCheckboxChange(value);
                setState(() {
                  isChecked = value!;
                  price = widget.price;
                });
              }
          ),
            Image.network(widget.image, height: 80,),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('\$${widget.price}',style:const TextStyle(fontSize: 18, color: Colors.orange)),
                    isChecked ?
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(' Quantity: $selectedQuantity',style:const TextStyle(fontSize: 15)),
                    )
                    :
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              if(selectedQuantity > 1){
                                setState((){
                                  selectedQuantity -=1;
                                });
                              }
                            },
                            icon: const  Icon(Icons.remove)
                        ),
                        Text('$selectedQuantity'),
                        IconButton(
                            onPressed: (){
                              if(selectedQuantity< widget.maxQuantity){
                                setState((){
                                  selectedQuantity +=1;
                                });
                              }

                            },
                            icon: const Icon(Icons.add)
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text('In stock: ${widget.maxQuantity}', style: const TextStyle(color: Colors.redAccent),)
                  ],
                )
              ],
            )
          ],
        )
      ],
    );


  }
}