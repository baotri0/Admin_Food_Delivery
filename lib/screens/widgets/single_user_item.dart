import 'package:admin/models/user_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constaints/routes.dart';

class SingleUserItem extends StatefulWidget {
  final UserModel userModel;
  final int index;
  const SingleUserItem({
    super.key,
    required this.userModel,
    required this.index,
  });

  @override
  State<SingleUserItem> createState() => _SingleUserItemState();
}

class _SingleUserItemState extends State<SingleUserItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            widget.userModel.image != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.image!),
                    // child: Icon(Icons.person),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userModel.name),
                Text(widget.userModel.email),
              ],
            ),
            Spacer(),
            isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: () {
                      showAlertDialog(context,appProvider);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
            SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () async {
                Routes.instance.push(
                    widget: EditUser(
                        index: widget.index, userModel: widget.userModel),
                    context: context);
              },
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
            .deleteUserFromFirebase(widget.userModel);
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
