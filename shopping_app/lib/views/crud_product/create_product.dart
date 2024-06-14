import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/repositories/repos/product_repository.dart';
import 'package:shopping_app/services/product_service.dart';
import 'package:shopping_app/viewmodels/product_viewmodel.dart';
import 'package:shopping_app/views/widgets/snackbar_widget.dart';

import '../../models/product.dart';
import '../../repositories/interfaces/product_interface.dart';
import '../../repositories/interfaces/product_service_interface.dart';

import '../widgets/input_field.dart';

class CreateProductScreent extends StatefulWidget {
  const CreateProductScreent({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<CreateProductScreent> createState() => _CreateProductScreentState();
}

class _CreateProductScreentState extends State<CreateProductScreent> {
  TextEditingController textNameController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  TextEditingController textPriceController = TextEditingController();
  TextEditingController textQuantityController = TextEditingController();
  TextEditingController textAddressController = TextEditingController();

  final key = GlobalKey<FormState>();
  FirebaseStorage  firebaseStorage = FirebaseStorage.instance;
  File? imageFile;
  bool visible = false;
  String imageUrl = '';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(()=> imageFile = imageTemp);
      String url = await convertFile(imageFile!);
      if(url.isNotEmpty){
        setState(()=> imageUrl = url);
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  Future<String> convertFile(File file) async{
    try{
      final storageRef = firebaseStorage.ref().child('avatars')
          .child('avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
      if(file != File('') && file.existsSync()){
        final uploadTask = storageRef.putFile(file);
        final snapshot = await Future.wait([uploadTask]);
        final imageUrl = await snapshot[0].ref.getDownloadURL();
        return imageUrl;
      }
      return '';
    }catch(e){
      print(e);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {

    final productViewModel = Provider.of<ProductViewModel>(context);
    final productService = Provider.of<IProductService>(context);
    if(widget.id.isNotEmpty){
      Product product = productViewModel.products!.where((p) => p.id == widget.id).first;
      setState(() {
        textNameController.text = product.name;
        textDescriptionController.text = product.description;
        textPriceController.text = product.price.toString();
        textQuantityController.text = product.quantity.toString();
        textAddressController.text = product.address;
        imageUrl = product.image;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.id.isEmpty ? const Text('Create product') : const Text('Update product'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: textNameController,
                    decoration: textInputField.copyWith(
                      labelText: 'Name',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return  "Please enter product's name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: textDescriptionController,
                    maxLines: 3,
                    decoration: textInputField.copyWith(
                      labelText: 'Description',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return  "Please enter product's description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: textPriceController,
                          decoration: textInputField.copyWith(
                            labelText: 'Price',
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return  "Please enter product's price";
                            }
                            if(double.parse(value) <=0){
                              return 'Price must be greater than 0';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: textQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: textInputField.copyWith(
                            labelText: 'Quantity',
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return  "Please enter product's quantity";
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null) {
                              return "Quantity must be an integer";
                            }
                            if (intValue <= 0) {
                              return 'Quantity must be greater than 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: textAddressController,
                    decoration: textInputField.copyWith(
                      labelText: 'Address',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return  "Please enter address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async{
                            await pickImage();
                            if(imageUrl.isNotEmpty){
                              setState(()=> visible = false);
                            }
                          },
                          child: const Text('Select image')
                      ),
                      // const SizedBox(width: 30),
                      imageUrl.isEmpty ? const Text('Not select image') : Image.network(imageUrl, width: 100,),
                    ],
                  ),
                  Visibility(
                      visible: visible,
                      child: const Text('Please select an image', style: TextStyle(color: Colors.red))),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                      ),
                      onPressed: (){
                        if(imageUrl.isEmpty){
                          setState(()=> visible = true);
                        }
                        if(key.currentState!.validate() && imageUrl.isNotEmpty){
                          ProductViewModel product = ProductViewModel(
                              productService,
                          );
                          product.id = null;
                          product.name = textNameController.text;
                          product.description = textDescriptionController.text;
                          product.price = double.parse(textPriceController.text);
                          product.quantity = int.parse(textQuantityController.text);
                          product.address = textAddressController.text;
                          product.image = imageUrl;
                          if(widget.id.isEmpty){
                            productViewModel.createProduct(product);
                            showSnackBar(context, "Product's created success", Colors.green);
                          }else{
                            productViewModel.updateProduct(widget.id, product);
                            showSnackBar(context, "Product's edited success", Colors.blueAccent);
                          }
                        }
                      },
                      child: widget.id.isEmpty ? const Text("Create") : const Text("Edit")
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
