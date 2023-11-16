import 'dart:io';

import 'package:admin/constaints/constants.dart';
import 'package:admin/firebase_helper/firebase_storage.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
  CategoryModel? _selectedCategory;
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
              ? CupertinoButton(
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
              hintText: "Product Name",
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButtonFormField(
              value: _selectedCategory,
              hint: Text(
                'Category',
              ),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: appProvider.getCategories.map((CategoryModel val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val.name,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: description,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: "Description",
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "\$ Price",
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () async {
              if (image == null ||
                  name.text.isEmpty ||
                  _selectedCategory == null ||
                  description.text.isEmpty ||
                  price.text.isEmpty) {
                showMessage("Please fill all information");
              } else {
                appProvider.addProductList(image!, name.text,
                    _selectedCategory!.id, description.text, price.text);
                showMessage("Successfully Added");
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
