import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF58BFFF);
const kBlueColor = Color(0xFF4498F8);
const kLightBlueColor = Color(0xFF4498F8);
const kTextColor = Color(0xFF030303);

final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

const String kPhoneNumberNullError = "Please Enter your phone number";
const String kCodeNullError = "Please Enter your code";

final otpInputDecoration = InputDecoration(
    contentPadding:
        EdgeInsets.symmetric(vertical: getProportionateScreenHeight(15)),
    enabledBorder: outlineInputBorder(),
    focusedBorder: outlineInputBorder(),
    border: outlineInputBorder());

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: kTextColor));
}
