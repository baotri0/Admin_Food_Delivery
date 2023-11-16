import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../constaints/constants.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import 'package:firebase_admin/firebase_admin.dart';

import 'firebase_storage.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<UserModel>> getUserList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection("users").get();
    return querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<String> deleteSingleUser(String id) async {
    try {
      await _firebaseFirestore.collection("users").doc(id).delete();
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(userModel.id)
          .update(userModel.toJson());
    } catch (e) {}
  }

  Future<String> deleteSingleCategory(String id) async {
    try {
      //await _firebaseFirestore.collection("categories").doc(id).delete();
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateCategory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

  Future<CategoryModel> addCategory(File image, String name) async {
    DocumentReference reference =
        _firebaseFirestore.collection("categories").doc();
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadUserImage(reference.id, image);
    CategoryModel addCategory =
        CategoryModel(image: imageUrl, id: reference.id, name: name);
    await reference.set(addCategory.toJson());
    return addCategory;
  }

  /// Product
  Future<List<ProductModel>> getProduct() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collectionGroup("products").get();
    List<ProductModel> productList =
        querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
    return productList;
  }

  Future<String> deleteProduct(String categoryId, String productId) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryId)
          .collection("products")
          .doc(productId)
          .delete();
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateProduct(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(productModel.categoryId)
          .collection("products")
          .doc(productModel.id)
          .update(productModel.toJson());
    } catch (e) {}
  }

  Future<ProductModel> addProduct(
    File image,
    String name,
    String categoryId,
    String description,
    String price,
  ) async {
    DocumentReference reference = _firebaseFirestore
        .collection("categories")
        .doc(categoryId)
        .collection("products")
        .doc();
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadUserImage(reference.id, image);
    ProductModel addProduct = ProductModel(
      image: imageUrl,
      id: reference.id,
      name: name,
      categoryId: categoryId,
      description: description,
      isFavourite: false,
      price: double.parse(price),
      qty: 1,
    );
    await reference.set(addProduct.toJson());
    return addProduct;
  }

  //Order
  Future<List<OrderModel>> getCompletedOrder() async {
    QuerySnapshot<Map<String, dynamic>> completedOrder =
        await _firebaseFirestore.collection("orders").where("status",isEqualTo: "Completed").get();
    List<OrderModel> completedOrderList =
        completedOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

  Future<List<OrderModel>> getCancelledOrder() async {
    QuerySnapshot<Map<String, dynamic>> cancelledOrder =
    await _firebaseFirestore.collection("orders").where("status",isEqualTo: "Cancel").get();
    List<OrderModel> cancelledOrderList =
    cancelledOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return cancelledOrderList;
  }

  Future<List<OrderModel>> getPendingOrder() async {
    QuerySnapshot<Map<String, dynamic>> pendingOrder =
    await _firebaseFirestore.collection("orders").where("status",isEqualTo: "Pending").get();
    List<OrderModel> pendingOrderList =
    pendingOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return pendingOrderList;
  }

  Future<List<OrderModel>> getDeliveryOrder() async {
    QuerySnapshot<Map<String, dynamic>> deliveryOrder =
    await _firebaseFirestore.collection("orders").where("status",isEqualTo: "Delivery").get();
    List<OrderModel> deliveryOrderList =
    deliveryOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return deliveryOrderList;
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection("usersOrders")
        .doc(orderModel.userId)
        .collection("orders")
        .doc(orderModel.orderId)
        .update({
      "status": status,
    });
    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderId)
        .update({
      "status": status,
    });
  }
}
