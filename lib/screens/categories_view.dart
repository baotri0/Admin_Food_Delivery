import 'package:admin/models/category_model.dart';
import 'package:admin/models/user_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/add_category.dart';
import 'package:admin/screens/widgets/single_category_item.dart';
import 'package:admin/screens/widgets/single_user_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constaints/routes.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories View"),
        actions: [
          IconButton(onPressed: (){
            Routes.instance.push(widget: AddCategory(), context: context);
          }, icon: Icon(Icons.add_circle))
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: value.getCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      CategoryModel categoryModel =
                          value.getCategories[index];
                      return SingleCategoryItem(categoryModel: categoryModel, index: index,);
                      // return SingleUserItem(userModel: categoryModel,index: index, );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
