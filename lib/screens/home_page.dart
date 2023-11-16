import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/categories_view.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:admin/screens/widgets/single_dash_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constaints/routes.dart';
import 'order_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.callBackFunc();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "email@gmail.com",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // SizedBox(
                    //   height: 12,
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text("Send Notification to all user"),
                    // ),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.only(top: 12),
                      crossAxisCount: 2,
                      children: [
                        SingleDashItem(
                          title: appProvider.getUserList.length.toString(),
                          subtitle: "Users",
                          onPressed: () {
                            Routes.instance.push(
                                widget: const UserView(), context: context);
                          },
                        ),
                        SingleDashItem(
                          title: appProvider.getCategories.length.toString(),
                          subtitle: "Categories",
                          onPressed: () {
                            Routes.instance.push(
                                widget: const CategoriesView(),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          title: appProvider.getProduct.length.toString(),
                          subtitle: "Products",
                          onPressed: () {
                            Routes.instance.push(
                                widget: const ProductView(), context: context);
                          },
                        ),
                        SingleDashItem(
                          title: "\$${appProvider.totalEarning}",
                          subtitle: "Earning",
                          onPressed: () {},
                        ),
                        SingleDashItem(
                          title:
                              appProvider.getPendingOrderList.length.toString(),
                          subtitle: "Pending Order",
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Pending Order",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          title: appProvider.getDeliveryOrderList.length
                              .toString(),
                          subtitle: "Delivery Order",
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Delivery Order",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          title: appProvider.getCancelledOrderList.length
                              .toString(),
                          subtitle: "Cancelled Order",
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Cancelled Order",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          title: appProvider.getCompletedOrderList.length
                              .toString(),
                          subtitle: "Completed Order",
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Completed Order",
                                ),
                                context: context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
