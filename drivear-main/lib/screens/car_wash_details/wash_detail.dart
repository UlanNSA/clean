import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/favourite_carwash.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/screens/car_wash_details/components/wash_information.dart';
import 'package:car_wash/screens/car_wash_details/components/wash_navigation.dart';
import 'package:car_wash/screens/car_wash_details/components/wash_reviews.dart';
import 'package:car_wash/screens/new_order/new_order_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/wash_services.dart';

class WashDetail extends StatefulWidget {
  final Wash carWash;
  static String routeName = "/carWashDetail";
  WashDetail({Key? key, required this.carWash}) : super(key: key);

  @override
  _WashDetailState createState() => _WashDetailState();
}

class _WashDetailState extends State<WashDetail> {
  int _currentTab = 0;
  late List<Widget> _widgetOptions;
  bool likeOrDislike = false;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      WashServices(carWash: widget.carWash,),
      WashNavigation(carWash: widget.carWash),
      WashInformation(carWash: widget.carWash),
      WashReviews(carWash: widget.carWash,),
    ];
    fetchLike();
  }

  fetchLike () async {
    final _likeOrDislike = await getLikeOrDislike();
    setState(() {
      likeOrDislike = _likeOrDislike;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider _authProvider = serviceLocator<AuthProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.carWash.name!, style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: kPrimaryColor,
          actions: [
            GestureDetector(
              child: !likeOrDislike ? Icon(Icons.favorite_border, size: getProportionateScreenWidth(20),) : Icon(Icons.favorite, size: getProportionateScreenWidth(20),),
              onTap: () async {
                await _authProvider.likeOrUnlikeCarwash(widget.carWash.id!);
                getLikeOrDislike();
                fetchLike();
              },
            ),
            SizedBox(width: 20,)
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: getProportionateScreenHeight(180),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/temp2.jpg"),
                        ),
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/local_offer.svg"),
                      SizedBox(width: getProportionateScreenHeight(5)),
                      Text(
                        '${1000}-${2200}tg',
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: Text(
                    "TO BOOK",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.white),
                  ),
                  height: 44,
                  color: kPrimaryColor,
                  press: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewOrderScreen(carWash: widget.carWash)));
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(120),
                          child: DefaultButton(
                            text: Text(
                              "Service",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: _currentTab == 0
                                      ? Colors.white
                                      : kPrimaryColor),
                            ),
                            color: _currentTab == 0
                                ? Color(0x4D53B175)
                                : Color(0xFFFFFF),
                            height: 40,
                            press: () {
                              setState(() {
                                _currentTab = 0;
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          width: getProportionateScreenWidth(130),
                          child: DefaultButton(
                            text: Text(
                              "Information",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: _currentTab == 2
                                      ? Colors.white
                                      : kPrimaryColor),
                            ),
                            color: _currentTab == 2
                                ? Color(0x4D53B175)
                                : Color(0xFFFFFF),
                            height: 40,
                            press: () {
                              setState(() {
                                _currentTab = 2;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(125),
                          child: DefaultButton(
                            text: Text(
                              "Reviews",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: _currentTab == 3
                                      ? Colors.white
                                      : kPrimaryColor),
                            ),
                            color: _currentTab == 3
                                ? Color(0x4D53B175)
                                : Color(0xFFFFFF),
                            height: 40,
                            press: () {
                              setState(() {
                                _currentTab = 3;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                _widgetOptions[_currentTab],
                ],
            ),
          ),
        ));
  }

  Future<bool> getLikeOrDislike() async {
    AuthProvider _authProvider = serviceLocator<AuthProvider>();
    FavouriteCarwashList list =  FavouriteCarwashList.fromSnapshot(await FirebaseFirestore.instance.collection('favourites').doc(_authProvider.currentUser!.id!).get());
    if (list.list!.length > 0) {
      return list.list![list.list!.indexWhere((element) => element.id == widget.carWash.id)].likeOrDislike ?? false;
    }else {
      return false;
    }
  }
}

