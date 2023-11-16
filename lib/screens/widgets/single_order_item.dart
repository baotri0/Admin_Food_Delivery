import 'package:admin/constaints/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_helper/firebase_firestore.dart';
import '../../models/order_model.dart';
import '../../provider/app_provider.dart';

class SingleOrderItem extends StatelessWidget {
  final OrderModel orderModel;
  const SingleOrderItem({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedShape: RoundedRectangleBorder(
            side:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.3)),
        shape: RoundedRectangleBorder(
            side:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.3)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              height: 150,
              width: 120,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              child: Image.network(
                orderModel.products[0].image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer: ${orderModel.customer}",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Address: ${orderModel.address}",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Phone: ${orderModel.phone}",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Total Price: \$${orderModel.totalPrice.toString()}",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Order Status: ${orderModel.status}",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text("Send to Delivery"),
                  // ),
                  SizedBox(
                    height: 12,
                  ),
                  orderModel.status == "Pending"
                      ? CupertinoButton(
                          onPressed: () async {
                            await FirebaseFirestoreHelper.instance
                                .updateOrder(orderModel, "Delivery");
                            orderModel.status = "Delivery";
                            appProvider.updatePendingOrder(orderModel);
                            },
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 48,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Send to Delivery",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  SizedBox(height: 12,),
                  orderModel.status == "Pending"
                      ? CupertinoButton(
                          onPressed: () async {
                            await FirebaseFirestoreHelper.instance
                                .updateOrder(orderModel, "Cancel");
                            orderModel.status="Cancel";
                            appProvider.cancelPendingOrder(orderModel);
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 48,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Cancel Order",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                ],
              ),
            ),
          ],
        ),
        children: orderModel.products.length > 1
            ? [
                const Text("Details"),
                Divider(color: Theme.of(context).primaryColor),
                ...orderModel.products.map((singleProduct) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              child: Image.network(
                                singleProduct.image,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    singleProduct.name,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Quanity: ${singleProduct.qty.toString()}",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Price: \$${singleProduct.price.toString()}",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                      ],
                    ),
                  );
                }).toList()
              ]
            : [],
      ),
    );
  }
}

//3:56:20k
