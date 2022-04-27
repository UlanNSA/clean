import 'dart:developer';

import 'package:car_wash/constans.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceCard extends StatelessWidget {
  final int? minPrice;
  final int? maxPrice;
  final String? name;
  final String? image;

  const ServiceCard({
    Key? key,
    this.minPrice,
    this.maxPrice,
    this.name,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xFF979797)),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                  height: getProportionateScreenWidth(65),
                  width: getProportionateScreenWidth(70),
                  child: FutureBuilder(
                    future: _getServiceImage(context, image!),
                    builder: (BuildContext context,
                        AsyncSnapshot<ImageProvider<Object>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: snapshot.data!, fit: BoxFit.cover),
                              color: Colors.red),
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ));
                      }
                    },
                  )),
              SizedBox(width: getProportionateScreenHeight(10)),
              SizedBox(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name!),
                  Text("$minPrice-${maxPrice}tg"),
                ],
              )),
              Spacer(),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/aboutIconGreen.svg")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<ImageProvider> _getServiceImage(
      BuildContext context, String imagePath) async {
    final FireStorageProvider _storageProvider =
        serviceLocator<FireStorageProvider>();

    ImageProvider? image;
    await _storageProvider
        .loadImageByFullpath(context, imagePath)
        .then((value) {
      try {
        image = NetworkImage(value);
      } catch (e) {
        log(e.toString());
      }
    });

    return image!;
  }
}
