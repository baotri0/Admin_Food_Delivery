import 'package:admin/models/product_model.dart';
import 'package:admin/screens/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constaints/routes.dart';
import '../../provider/app_provider.dart';

class SingleProductView extends StatefulWidget {
  final ProductModel singleProduct;
  final int index;
  const SingleProductView(
      {super.key, required this.singleProduct, required this.index});

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Card(
      color: Colors.greenAccent.withOpacity(0.7),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                Image.network(
                  widget.singleProduct.image,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  widget.singleProduct.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Price: \$${widget.singleProduct.price}"),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: Row(
              children: [
                IgnorePointer(
                  ignoring: isLoading,
                  child: GestureDetector(
                    onTap: ()  {
                      showAlertDialog(context,appProvider);
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Routes.instance.push(
                        widget: EditProduct(
                            productModel: widget.singleProduct,
                            index: widget.index),
                        context: context);
                  },
                  child: Icon(Icons.edit),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, AppProvider appProvider) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await appProvider.deleteProductFromFirebase(widget.singleProduct);
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Your actions cannot be undone. Do you want to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
