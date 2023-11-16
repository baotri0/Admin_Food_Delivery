import 'dart:io';

import 'package:admin/constaints/constants.dart';
import 'package:admin/firebase_helper/firebase_firestore.dart';
import 'package:admin/firebase_helper/firebase_storage.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key,});

  @override
  State<AddCategory> createState() => _AddCategorytate();
}

class _AddCategorytate extends State<AddCategory> {
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
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add Category",
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
                radius: 55, child: Icon(Icons.camera_alt)),
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
              hintText: "Category Name",
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () async {
              if (image == null && name.text.isEmpty) {
                Navigator.of(context).pop();
              } else if (image != null && name.text.isNotEmpty) {

                appProvider.addCategoryList(image!, name.text);
                showMessage("Successfully Addded");
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
