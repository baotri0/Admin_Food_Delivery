import 'package:admin/models/product_model.dart';

class OrderModel {
  OrderModel({
    required this.totalPrice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.address,
    required this.customer,
    required this.phone,
    required this.userId,
  });

  String payment;
  String status;
  String address;
  String customer;
  String phone;
  List<ProductModel> products;
  double totalPrice;
  String orderId;
  String userId;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      orderId: json["orderId"],
      userId: json["userId"],
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
      totalPrice: json["totalPrice"],
      status: json["status"],
      payment: json["payment"],
      address: json["address"],
      customer: json["customer"],
      phone: json["phone"],
    );
  }
}
