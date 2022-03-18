import 'package:car_wash/components/default_drawer.dart';
import 'package:car_wash/constans.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class MyOrdersScreen extends StatelessWidget {
  static String routeName = "/my_orders";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text("MY ORDERS", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800
        ),),
      ),
      body: Body(),
    );
  }
}