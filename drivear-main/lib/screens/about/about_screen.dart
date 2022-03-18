import 'package:car_wash/constans.dart';
import 'package:car_wash/screens/about/components/body.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static String routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(
          'ABOUT APPLICATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900
          )),
      ),
      body: Body(),
    );
  }
}
