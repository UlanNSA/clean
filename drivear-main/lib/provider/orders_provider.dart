import 'dart:async';
import 'dart:developer';

import 'package:car_wash/models/order_model.dart';
import 'package:car_wash/models/orders_response_model.dart';
import 'package:car_wash/models/user_model.dart';
import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/loading_provider.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/my_orders/my_order_screen.dart';
import 'package:car_wash/screens/sign_up/sign_up_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  FirebaseAuth _authProvider = FirebaseAuth.instance;
  AlertProvider _alertProvider = serviceLocator<AlertProvider>();

  Future<void> makeOrder(BuildContext context, Order order) async {
    try {
      DocumentReference _doc = FirebaseFirestore.instance
          .collection('orders')
          .doc(_authProvider.currentUser!.uid);
      DocumentReference _docCarwashOrder =
      FirebaseFirestore.instance.collection('carwash_orders').doc(order.carWashName!.id);

      DocumentSnapshot docOrder = await _doc.get();
      DocumentSnapshot docCarwashOrder = await _docCarwashOrder.get();

      order.id = docOrder.id;

      OrderResponse _response = docOrder.data() == null
          ? OrderResponse(orders: [])
          : OrderResponse.fromSnapshot(docOrder);
      if (_response.orders == null) {
        List<Order> _order = [order];
        _response.orders = _order;
      } else {
        _response.orders!.add(order);
      }

      OrderResponse _response2 = docCarwashOrder.data() == null
          ? OrderResponse(orders: [])
          : OrderResponse.fromSnapshot(docCarwashOrder);
      if (_response2.orders == null) {
        List<Order> _order = [order];
        _response2.orders = _order;
      } else {
        _response2.orders!.add(order);
      }

      Map<String, dynamic> _requestData = _response.toJson();
      Map<String, dynamic> _requestData2 = _response2.toJson();

      _doc.set(_requestData as Map<String, dynamic>);
      _docCarwashOrder.set(_requestData2 as Map<String, dynamic>);

      _alertProvider.showSuccessMessage(
          context, "Make Order", "You Successfully Make Order");
      Navigator.pushNamedAndRemoveUntil(context, MyOrdersScreen.routeName,
          (route) => route.settings.name == HomeScreen.routeName);
    } on Exception catch (e) {
      log(e.toString());
      _alertProvider.showErrorMessage(
          context, "Make Order", "Something went wrong!!!!");
    }
  }

  Future<List<Order>> fetchAll(BuildContext context) async {
    final _doc = FirebaseFirestore.instance
        .collection('orders')
        .doc(_authProvider.currentUser!.uid);
    final docOrder = await _doc.get();

    OrderResponse _response = docOrder.data() == null
        ? OrderResponse(orders: [])
        : OrderResponse.fromSnapshot(docOrder);
    log(_response.toJson().toString());
    return _response.orders != null ? _response.orders! : [];
  }
}
