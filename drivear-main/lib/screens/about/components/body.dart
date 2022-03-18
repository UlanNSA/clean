import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(140)),
            Image.asset('assets/images/logoWhite.png'),
            SizedBox(height: getProportionateScreenWidth(120)),
            Text('VERSION 1.0.1(101)'),
            SizedBox(height: getProportionateScreenWidth(240)),
            Text('(C) 2021 LIN'),
          ],
        ),
      ),
    );
  }
}
