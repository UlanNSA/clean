import 'package:car_wash/constans.dart';
import 'package:car_wash/screens/sign_up/components/body.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child:
            Container(
              child: AppBar(
                backgroundColor: kPrimaryColor,
                title: Image.asset("assets/images/logo.png"),
                centerTitle: true,
              ),
            ),
      ),
      body: Body(formKey: _formKey,),
    );
  }
}
