import 'dart:developer';

import 'package:car_wash/components/default_drawer.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/screens/google_maps/GoogleMapsScreen.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/screens/main/components/car_wash_list.dart';
import 'package:car_wash/screens/my_orders/my_order_screen.dart';
import 'package:car_wash/size_config.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:car_wash/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Wash> _carWashList = [
    // CarWash("НАВИГАТОР, комплекс", "", [], LatLng(43.259321, 76.911274), 4.5, 1200),
    // CarWash("Ehrle.RW, автомойка самообслуживания", "", [],
    //     LatLng(43.233024, 76.954797), 4.5, 1500),
    // CarWash("Ehrle.RW, автомойка самообслуживания", "", [],
    //     LatLng(43.334018, 76.979171), 4.5, 1300),
    // CarWash("AVTOБАНЯ #1", "", [], LatLng(43.211757, 76.902433), 4.5, 1400),
    // CarWash("КазШинТорг, компания по продаже шин", "", [],
    //     LatLng(43.255526, 76.903548), 4.5, 2000),
  ];
  var _screenState = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              child: AppBar(
                backgroundColor: kPrimaryColor,
                title: Image.asset(
                  "assets/images/logo2.png",
                  height: getProportionateScreenWidth(40),
                ),
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _screenState = !_screenState;
                      });
                    },
                    child: SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/listIcon.svg"),
                          SizedBox(width: getProportionateScreenWidth(5)),
                          Text(
                            _screenState ? "The list" : "The Map",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(width: getProportionateScreenWidth(5)),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
      drawer: buildDrawer(context: context),
      body: _screenState == true
          ? GoogleMapsScreen(cameraPosition: LatLng(43.25654, 76.92848))
          : CarWashList(),
    );
  }




}

