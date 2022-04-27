import 'package:car_wash/screens/about/about_screen.dart';
import 'package:car_wash/screens/addresses_screen/addresses_screen.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/my_orders/my_order_screen.dart';
import 'package:car_wash/screens/otp/otp_screen.dart';
import 'package:car_wash/screens/profile/profile_screen.dart';
import 'package:car_wash/screens/sign_in/sign_in_screen.dart';
import 'package:car_wash/screens/sign_up/sign_up_screen.dart';
import 'package:car_wash/screens/splash/splash_screen.dart';
import 'package:car_wash/screens/favourite/favourite_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  OTPScreen.routeName: (context) => OTPScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyOrdersScreen.routeName: (context) => MyOrdersScreen(),
  FavouriteScreen.routeName: (context) => FavouriteScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  AboutScreen.routeName: (context) => AboutScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  AddressesScreen.routeName: (context) => AddressesScreen(),
};
