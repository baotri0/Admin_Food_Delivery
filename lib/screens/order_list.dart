import 'package:admin/screens/widgets/single_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../provider/app_provider.dart';

class OrderList extends StatelessWidget {
  final String title;
  const OrderList(
      {super.key, required this.title});

  List<OrderModel> getOderList(AppProvider appProvider) {
    if (title == "Pending Order") {
      return appProvider.getPendingOrderList;
    } else if (title == "Delivery Order") {
      return appProvider.getDeliveryOrderList;
    } else if (title == "Completed Order") {
      return appProvider.getCompletedOrderList;
    } else if (title == "Cancel Order") {
      return appProvider.getCancelledOrderList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("${title} List"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: getOderList(appProvider).isEmpty
            ? Center(
                child: Text("${title} is empty"),
              )
            : ListView.builder(
                itemCount: getOderList(appProvider).length,
                itemBuilder: (context, index) {
                  OrderModel orderModel = getOderList(appProvider)[index];
                  return SingleOrderItem(orderModel: orderModel);
                },
              ),
      ),
    );
  }
}
