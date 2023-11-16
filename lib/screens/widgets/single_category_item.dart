
import 'package:admin/models/category_model.dart';
import 'package:admin/screens/edit_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constaints/routes.dart';
import '../../provider/app_provider.dart';

class SingleCategoryItem extends StatefulWidget {
  final CategoryModel categoryModel;
  final int index;
  const SingleCategoryItem({super.key, required this.categoryModel, required this.index});

  @override
  State<SingleCategoryItem> createState() => _SingleCategoryItemState();
}

class _SingleCategoryItemState extends State<SingleCategoryItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              child: Image.network(
                widget.categoryModel.image,
                scale: 2,
              ),
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
                    Routes.instance.push(widget: EditCategory(categoryModel: widget.categoryModel, index: widget.index), context: context);
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
        await appProvider
            .deleteCategoryFromFirebase(widget.categoryModel);
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
