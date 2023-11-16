import 'package:admin/models/user_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/widgets/single_user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User View"),
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.getUserList.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              UserModel userModel = value.getUserList[index];
              return SingleUserItem(userModel: userModel,index: index, );
            },
          );
        },
      ),
    );
  }
}
