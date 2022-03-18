import 'dart:developer';
import 'dart:math';

import 'package:car_wash/components/default_bottom_navigator.dart';
import 'package:car_wash/components/default_drawer.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/favourite_carwash.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/car_wash_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/provider/info_window_model.dart';
import 'package:car_wash/screens/car_wash_details/car_wash_detail.dart';
import 'package:car_wash/screens/favourite/components/body.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/main/main_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class FavouriteScreen extends StatelessWidget {
  static String routeName = "/favourite";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          height: double.infinity,
          child: AppBar(
            toolbarHeight: double.infinity,
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15)),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search),
                            fillColor: Colors.white,
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            hintText: 'Search Favourites'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: buildDrawer(context: context),
      body: Body()
    );
  }


}
