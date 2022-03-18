import 'package:car_wash/components/default_drawer.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/screens/profile/components/body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: buildDrawer(context: context),
      body: Body(

      ),
    );
  }
}
