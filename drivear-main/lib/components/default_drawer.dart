import 'dart:developer';

import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/screens/about/about_screen.dart';
import 'package:car_wash/screens/addresses_screen/addresses_screen.dart';
import 'package:car_wash/screens/favourite/favourite_screen.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/my_orders/my_order_screen.dart';
import 'package:car_wash/screens/profile/profile_screen.dart';
import 'package:car_wash/screens/sign_in/sign_in_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constans.dart';
import '../size_config.dart';

FireStorageProvider _storageProvider = serviceLocator<FireStorageProvider>();

Widget buildDrawer({context}) {
  AuthProvider _authProvider = serviceLocator<AuthProvider>();

  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                height: getProportionateScreenWidth(150),
                child: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: getProportionateScreenWidth(50),
                            width: getProportionateScreenWidth(50),
                            child: ClipRect(
                                child: _authProvider.currentUser != null &&
                                        _authProvider.currentUser!.id != null
                                    ? FutureBuilder(
                                        future: _getProfileImage(context,
                                            '${_authProvider.currentUser!.id!}.png'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<ImageProvider<Object>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: DecorationImage(
                                                      image: snapshot.data!,
                                                      fit: BoxFit.cover)),
                                            );
                                          } else {
                                            return CircularProgressIndicator(
                                              color: kPrimaryColor,
                                            );
                                          }
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/profIcon.png')),
                          ),
                          Container(
                            height: getProportionateScreenWidth(40),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(5)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        _authProvider.currentUser != null
                                            ? _authProvider
                                                    .currentUser!.displayName ??
                                                'Not defined'
                                            : 'Not Defined',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(5),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.pushNamed(context, ProfileScreen.routeName);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HomeScreen(
                                                            selectedIndex: 3,
                                                          )),
                                              (route) => true);
                                        },
                                        child: SvgPicture.asset(
                                            "assets/icons/editIcon.svg"),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _authProvider.currentUser != null &&
                                                _authProvider
                                                        .currentUser!.email !=
                                                    null
                                            ? _authProvider.currentUser!.email!
                                            : "Not defined",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                ),
              ),
              buildListTile(
                  leadingIcon: "assets/icons/OrdersIcon.svg",
                  titleText: "Orders",
                  onClick: () {
                    Navigator.pushNamed(context, MyOrdersScreen.routeName);
                  }),
              Divider(
                height: 1,
              ),
              buildListTile(
                  leadingIcon: "assets/icons/DeliceryAddress.svg",
                  titleText: "Addresses",
                  onClick: () {
                    Navigator.pushNamed(context, AddressesScreen.routeName);
                  }),
              Divider(
                height: 1,
              ),

              buildListTile(
                  leadingIcon: "assets/icons/aboutIcon.svg",
                  titleText: "About",
                  onClick: () {
                    Navigator.pushNamed(context, AboutScreen.routeName);
                  }),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: buildLogOutButton(context: context),
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        )
      ],
    ),
  );
}

Future<ImageProvider> _getProfileImage(
    BuildContext context, String imageName) async {
  ImageProvider? image;
  await _storageProvider
      .loadImage(context, '/images/', imageName)
      .then((value) {
    try {
      image = NetworkImage(value);
    } catch (e) {
      log(e.toString());
    }
  }).onError((error, stackTrace) {
    image = Image.asset('assets/images/defaultProf.png').image;
  });

  return image!;
}

Container buildLogOutButton({required context}) {
  return Container(
      child: Column(
    children: <Widget>[
      SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(56),
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color(0xFFF2F3F2),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, SignInScreen.routeName);
            },
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/exitIcon.svg"),
                Spacer(),
                Text(
                  "Log Out",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer()
              ],
            )),
      )
    ],
  ));
}

ListTile buildListTile({required leadingIcon, required titleText, onClick}) {
  return ListTile(
    dense: true,
    leading: SvgPicture.asset(leadingIcon),
    title: Text(titleText),
    trailing: SvgPicture.asset("assets/icons/VectorRightBlack.svg"),
    onTap: onClick,
  );
}
