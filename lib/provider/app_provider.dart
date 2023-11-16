// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:admin/models/category_model.dart';
import 'package:admin/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constaints/constants.dart';
import '../firebase_helper/firebase_firestore.dart';
import '../firebase_helper/firebase_storage.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class AppProvider with ChangeNotifier {
  List<UserModel> _userList = [];
  List<CategoryModel> _categoriesList = [];
  List<ProductModel> _productList = [];
  List<OrderModel> _completedOrderList = [];
  List<OrderModel> _cancelledOrderList = [];
  List<OrderModel> _pendingOrderList = [];
  List<OrderModel> _deliveryOrderList = [];
  double _totalEarning = 0.0;


  Future<void> getUserListFunc() async {
    _userList = await FirebaseFirestoreHelper.instance.getUserList();
  }

  Future<void> getCompletedOrderFunc() async {
    _completedOrderList = await FirebaseFirestoreHelper.instance.getCompletedOrder();
    int i = _completedOrderList.length;
    for(var element in _completedOrderList) {
      _totalEarning +=  element.totalPrice;
    }
    notifyListeners();
  }

  Future<void> getCancelledOrderFunc() async {
    _cancelledOrderList = await FirebaseFirestoreHelper.instance.getCancelledOrder();
    notifyListeners();
  }

  Future<void> getPendingOrderFunc() async {
    _pendingOrderList = await FirebaseFirestoreHelper.instance.getPendingOrder();
    notifyListeners();
  }

  Future<void> getDeliveryOrderFunc() async {
    _deliveryOrderList = await FirebaseFirestoreHelper.instance.getDeliveryOrder();
    notifyListeners();
  }

  Future<void> getCategoryFunc() async {
    _categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
  }

  Future<void> deleteUserFromFirebase(UserModel userModel) async {
    notifyListeners();
    String value =
        await FirebaseFirestoreHelper.instance.deleteSingleUser(userModel.id);
    if (value == "Successfully Deleted") {
      _userList.remove(userModel);
      showMessage("Successfully Deleted");
    }
    notifyListeners();
  }

  List<UserModel> get getUserList => _userList;
  List<CategoryModel> get getCategories => _categoriesList;
  List<ProductModel> get getProduct => _productList;
  double get totalEarning => _totalEarning;
  List<OrderModel> get getCompletedOrderList => _completedOrderList;
  List<OrderModel> get getCancelledOrderList => _cancelledOrderList;
  List<OrderModel> get getPendingOrderList => _pendingOrderList;
  List<OrderModel> get getDeliveryOrderList => _deliveryOrderList;

  Future<void> callBackFunc() async {
    await getUserListFunc();
    await getCategoryFunc();
    await getProductList();
    await getCompletedOrderFunc();
    await getCancelledOrderFunc();
    await getPendingOrderFunc();
    await getDeliveryOrderFunc();
  }

  void updateUserList(int index, UserModel userModel) async {
    await FirebaseFirestoreHelper.instance.updateUser(userModel);
    _userList[index] = userModel;
    notifyListeners();
  }

  /// Category
  Future<void> deleteCategoryFromFirebase(CategoryModel categoryModel) async {
    notifyListeners();
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleCategory(categoryModel.id);
    if (value == "Successfully Deleted") {
      _categoriesList.remove(categoryModel);
      showMessage("Successfully Deleted");
    }
    notifyListeners();
  }

  void updateCategoryList(int index, CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance.updateCategory(categoryModel);
    _categoriesList[index] = categoryModel;
    notifyListeners();
  }

  void addCategoryList(File image, String name) async {
    CategoryModel categoryModel =
        await FirebaseFirestoreHelper.instance.addCategory(image, name);
    _categoriesList.add(categoryModel);
    notifyListeners();
  }

  Future<void> getProductList() async {
    _productList = await FirebaseFirestoreHelper.instance.getProduct();
    notifyListeners();
  }

  Future<void> deleteProductFromFirebase(ProductModel productModel) async {
    notifyListeners();
    String value = await FirebaseFirestoreHelper.instance
        .deleteProduct(productModel.categoryId, productModel.id);
    if (value == "Successfully Deleted") {
      _productList.remove(productModel);
      showMessage("Successfully Deleted");
    }
    notifyListeners();
  }

  void updateProductList(int index, ProductModel productModel) async {
    await FirebaseFirestoreHelper.instance.updateProduct(productModel);
    _productList[index] = productModel;
    notifyListeners();
  }

  void addProductList(
    File image,
    String name,
    String categoryId,
    String description,
    String price,
  ) async {
    ProductModel productModel =
        await FirebaseFirestoreHelper.instance.addProduct(image, name,categoryId,description,price);
    _productList.add(productModel);
    notifyListeners();
  }

  void updatePendingOrder(OrderModel orderModel){
    _deliveryOrderList.add(orderModel);
    _pendingOrderList.remove(orderModel);
    showMessage("Send to Delivery");
    notifyListeners();
  }

  void cancelPendingOrder(OrderModel orderModel){
    _cancelledOrderList.add(orderModel);
    _pendingOrderList.remove(orderModel);
    showMessage("Succefully Cancel");
    notifyListeners();
  }
}
