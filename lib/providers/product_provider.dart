import '../models/product.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> orders = [];

  num totalAmount = 0;

  late Map<String, dynamic> userData;

  addNewOrder({required Product product}) {
    orders.add(product);
    totalAmount = totalAmount + (product.productPrice * product.amount);
    notifyListeners();
  }

  removeOrder(int index) {
    totalAmount =
        totalAmount - (orders[index].productPrice * orders[index].amount);
    orders.removeAt(index);
    if (orders.isEmpty) {
      totalAmount = 0;
    }
    notifyListeners();
  }

  updateUserData({required Map<String, dynamic> newUserData}) {
    userData = newUserData;
    notifyListeners();
  }
}
