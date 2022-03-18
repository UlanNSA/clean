import 'package:car_wash/constans.dart';
import 'package:car_wash/screens/splash/components/body.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xF0C1AD7),
      body: Body()
    );
  }
}
