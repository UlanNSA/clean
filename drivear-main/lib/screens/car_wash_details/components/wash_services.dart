import 'dart:developer';

import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/models/order_model.dart';
import 'package:car_wash/models/orders_response_model.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/screens/car_wash_details/components/wash_service_card.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class WashServices extends StatelessWidget {
  final Wash carWash;

  const WashServices({
    Key? key,
    required this.carWash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> allTimes = [
      '09 : 00',
      '10 : 00',
      '11 : 00',
      '12 : 00',
      '13 : 00',
      '14 : 00',
      '15 : 00',
      '16 : 00',
      '17 : 00',
      '18 : 00',
      '19 : 00'
    ];
    String now = DateFormat('dd-MMMM').format(DateTime.now());

    Future<List<Order>?> _fetchOpenedTime(BuildContext context) async {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('carwash_orders')
          .doc(carWash.id);
      DocumentSnapshot? docSnap = await docRef.get();

      OrderResponse _response = docSnap.data() == null
          ? OrderResponse(orders: [])
          : OrderResponse.fromSnapshot(docSnap);

      return _response.orders;
    }

    Future<List<String>?> _rentedTime(BuildContext context) async {
      List<Order>? rentedTime = await _fetchOpenedTime(context);

      List<String> rentedTimes = rentedTime != null
          ? rentedTime
              .where((element) => element.date!.compareTo(DateTime.now()) != 0)
              .where((element) =>
                  element.time!.hour >= 9 && element.time!.hour <= 19)
              .map((e) {
              return '${e.time!.hour > 9 ? e.time!.hour : '0${e.time!.hour}'} : 00';
            }).toList()
          : [];

      List<String> copy = [];
      rentedTimes.sort((a, b) {
        return a.split(' : ')[0].compareTo(b.split(' : ')[0]);
      });

      rentedTimes.forEach((e) {
        if (copy.contains(e)) {
        } else {
          copy.add(e);
        }
      });
      return copy;
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 3),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/freeTimeIcon.svg"),
                    SizedBox(width: getProportionateScreenWidth(5)),
                    Text(
                      "FREE TIME",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: getProportionateScreenWidth(20)),
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  children: [
                    Text(
                      "Today $now",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: getProportionateScreenWidth(18)),
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                FutureBuilder(
                  future: _rentedTime(context),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: 50,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allTimes.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text('${allTimes[index]}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    18))),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: snapshot.data!
                                                .contains(allTimes[index])
                                            ? Color(0x4D53B175)
                                            : kPrimaryColor),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(5))
                                ],
                              );
                            }),
                      );
                    } else {
                      return CircularProgressIndicator(
                        color: kPrimaryColor,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(25)),
            child: Column(
              children: _getServices(context, carWash.services!),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getServices(
      BuildContext context, List<WashService> services) {
    List<Widget> childs = [];

    for (var i = 0; i < services.length; i++) {
      if (i == 0) {
        childs.add(SizedBox(
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/listIconBlack.svg"),
              SizedBox(
                width: getProportionateScreenWidth(5),
              ),
              Text(
                "SERVICE INFORMATION",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: getProportionateScreenWidth(15)),
              )
            ],
          ),
        ));
        childs.add(SizedBox(height: getProportionateScreenHeight(30)));
      }
      childs.add(ServiceCard(
        name: services[i].name,
        minPrice: 500,
        maxPrice: services[i].price,
        image: services[i].imageUrl,
      ));
      childs.add(SizedBox(height: getProportionateScreenHeight(30)));
      if (i == 0) {
        childs.add(SizedBox(
          child: Row(
            children: [
              Text(
                "ADDITIONALLY",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: getProportionateScreenWidth(15)),
              )
            ],
          ),
        ));
      }
    }

    return childs;
  }
}
