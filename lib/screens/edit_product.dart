import 'dart:io';

import 'package:admin/constaints/constants.dart';
import 'package:admin/firebase_helper/firebase_firestore.dart';
import 'package:admin/firebase_helper/firebase_storage.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  final int index;
  const EditProduct(
      {super.key, required this.productModel, required this.index});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Category",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          image == null
              ? widget.productModel.image.isNotEmpty
                  ? CupertinoButton(
                      onPressed: () {
                        takePicture();
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            NetworkImage(widget.productModel.image),
                      ),
                    )
                  : CupertinoButton(
                      onPressed: () {
                        takePicture();
                      },
                      child: const CircleAvatar(
                        radius: 55,
                        child: Icon(Icons.camera_alt),
                      ),
                    )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: widget.productModel.name,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: description,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: widget.productModel.description,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "\$${widget.productModel.price.toString()}",
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Update"),
            onPressed: () async {
              if (image == null && name.text.isEmpty && description.text.isEmpty && price.text.isEmpty) {
                Navigator.of(context).pop();
              } else if (image != null) {
                String imageUrl = await FirebaseStorageHelper.instance
                    .uploadUserImage(widget.productModel.id, image!);
                ProductModel productModel = widget.productModel.copyWith(
                  description:
                      description.text.isEmpty ? null : description.text,
                  image: imageUrl,
                  name: name.text.isEmpty ? null : name.text,
                  price: price.text.isEmpty ? null : price.text,
                );
                appProvider.updateProductList(widget.index, productModel);
                showMessage("Update Successfully");

              } else {
                ProductModel productModel = widget.productModel.copyWith(
                  description:
                      description.text.isEmpty ? null : description.text,
                  name: name.text.isEmpty ? null : name.text,
                  price: price.text.isEmpty ? null : price.text,
                );
                appProvider.updateProductList(widget.index, productModel);
                showMessage("Update Successfully");
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
