import 'package:admin/screens/add_product.dart';
import 'package:admin/screens/widgets/single_product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constaints/routes.dart';
import '../models/product_model.dart';
import '../provider/app_provider.dart';
import 'add_category.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Products View"),
        actions: [
          IconButton(
              onPressed: () {
                Routes.instance.push(widget: AddProduct(), context: context);
              },
              icon: Icon(Icons.add_circle))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Products",
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
                  itemCount: appProvider.getProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.8,
                      crossAxisCount: 2),
                  itemBuilder: (ctx, index) {
                    ProductModel singleProduct = appProvider.getProduct[index];
                    return SingleProductView(singleProduct: singleProduct,index: index,);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
