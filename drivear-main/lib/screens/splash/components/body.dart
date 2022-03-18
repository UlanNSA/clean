import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Spacer(),
              Container(
                height: getProportionateScreenHeight(290),
                color: kBlueColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Text(
                        "Welcome to LIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(48),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Text(
                        "Ger your groceries in as fast as one hour",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      DefaultButton(
                        text: Text(
                          "GET STARTED",
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white),
                        ),
                        press: () {},
                      ),
                      Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
