import 'dart:math';

import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/favourite_carwash.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Wash> favouriteList = [];
  bool isLoading = false;
  final FireStorageProvider _storageProvider =
      serviceLocator<FireStorageProvider>();

  @override
  void initState() {
    super.initState();
    getFavouriteList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: getFavouriteList,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(25),
            vertical: getProportionateScreenWidth(15)),
        child: isLoading ? Center(child: CircularProgressIndicator( color: kPrimaryColor,),) : GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: getProportionateScreenWidth(15),
            crossAxisSpacing: getProportionateScreenWidth(15),
            children: [
              ...favouriteList != null
                  ? favouriteList.map((e) => buildCard(context, e))
                  : []
            ]),
      ),
    );
  }

  Future<List<Wash>> getFavouriteList() async {
    setState(() {
      isLoading = true;
    });
    AuthProvider _authStorage = serviceLocator<AuthProvider>();
    DocumentSnapshot _docSnap = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(_authStorage.currentUser!.id)
        .get();
    FavouriteCarwashList _list = FavouriteCarwashList.fromSnapshot(_docSnap);
    List<Wash>? resultList = [];

    List<String> listIds = _list.list!
        .where((element) => element.likeOrDislike!)
        .map((e) => e.id!)
        .toList();

    if (listIds.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('car_wash')
          .where('id', whereIn: listIds)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((_docSnap) {
          Wash _carWash = Wash.fromSnapshot(_docSnap);
          resultList.add(_carWash);
        });
      });
      setState(() {
        favouriteList = resultList;
        isLoading = false;
      });
      return resultList;
    } else {
      setState(() {
        favouriteList = [];
        isLoading = false;
      });
      return [];
    }
  }

  Widget buildCard(BuildContext context, Wash carwash) {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.deepPurple,
      Colors.blue
    ];

    Random random = new Random();
    Color _color = colors[random.nextInt(5)];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WashDetail(carWash: carwash)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: _color.withOpacity(1)),
          borderRadius: BorderRadius.circular(20),
          color: _color.withOpacity(0.2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(5)),
          child: Column(
            children: [
              FutureBuilder(
                future: _getProfileImage(context, '${carwash.id}.png'),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data == null
                        ? Image.asset(
                            'assets/images/spray.png',
                            height: 70,
                            width: 110,
                          )
                        : snapshot.data!;
                  } else {
                    return CircularProgressIndicator(
                      color: kPrimaryColor,
                    );
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text('${carwash.name}')
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _getProfileImage(
      BuildContext context, String imageName) async {
    Image? image;
    await _storageProvider
        .loadImage(context, '/images/car_washs/', imageName)
        .then((value) {
      try {
        image = Image.network(
          value,
          height: 70,
          width: 110,
        );
      } catch (e) {}
    });

    return image!;
  }
}
