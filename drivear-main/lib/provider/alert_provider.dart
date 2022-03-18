import 'package:car_wash/constans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertProvider with ChangeNotifier {
  Future<dynamic> showSuccessMessage(
      BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: MediaQuery.of(context).size.height * .3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 5, color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(100)),
                      child: SvgPicture.asset('assets/icons/check.svg', width: 10, height: 10, fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  bottom: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w800),),
                      Text(message)
                    ],
                  ),
                )
              ],
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(),
        ));
  }

  showErrorMessage(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: MediaQuery.of(context).size.height * .3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 5, color: Colors.red),
                          borderRadius: BorderRadius.circular(100)),
                      child: SvgPicture.asset('assets/icons/close.svg', width: 10, height: 10, fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  bottom: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w800),),
                      Text(message)
                    ],
                  ),
                )
              ],
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(),
        ));
  }
}
