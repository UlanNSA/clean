import 'dart:developer';

import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CarWashList extends StatefulWidget {
  @override
  _CarWashListState createState() => _CarWashListState();
}

class _CarWashListState extends State<CarWashList> {
  final FireStorageProvider _storageProvider =
      serviceLocator<FireStorageProvider>();
  List<Wash> carwashList = [];
  bool isLoading = false;

  Future<void> fetchCarwashs() async {
    setState(() {
      isLoading = true;
    });
    FirebaseApi.readCarWashs().listen((event) {
      setState(() {
        carwashList = event;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCarwashs();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WashProvider>(context);
    final _carWashList = provider.carWashs!;

    return RefreshIndicator(
        child: isLoading ? Center(
          child: CircularProgressIndicator(color: kPrimaryColor,),
        ) : ListView.builder(
          itemCount: carwashList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WashDetail(carWash: _carWashList[index])),
                );
              },
              leading: FutureBuilder(
                future:
                _getProfileImage(context, '${_carWashList[index].id}.png'),
                builder: (BuildContext context,
                    AsyncSnapshot<ImageProvider<Object>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: snapshot.data == null
                                  ? Image.asset('assets/images/spray.png')
                                  .image
                                  : snapshot.data!,
                              fit: BoxFit.cover)),
                    );
                  } else {
                    return CircularProgressIndicator(
                      color: kPrimaryColor,
                    );
                  }
                },
              ),
              title: Text(
                '${_carWashList[index].name}',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('3km, Price'),
              trailing: SizedBox(
                width: 80,
                child: Row(
                  children: [
                    Text('${_carWashList[index].avgPrice} tg'),
                    Spacer(),
                    SvgPicture.asset("assets/icons/VectorRightBlack.svg")
                  ],
                ),
              ),
            );
          },
        ),
        onRefresh: fetchCarwashs);
  }

  Future<ImageProvider> _getProfileImage(
      BuildContext context, String imageName) async {
    ImageProvider? image;
    await _storageProvider
        .loadImage(context, '/images/car_washs/', imageName)
        .then((value) {
      try {
        image = NetworkImage(value);
      } catch (e) {
        log('TTTTTTTT ${e.toString()}');
      }
    });

    return image!;
  }
}
