import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CarWashInformation extends StatelessWidget {
  final CarWash carWash;

  const CarWashInformation({Key? key, required this.carWash}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    SvgPicture.asset("assets/icons/checkIcon.svg"),
                    SizedBox(width: getProportionateScreenWidth(5)),
                    Text(
                      "SERVICES",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: getProportionateScreenWidth(20)),
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Container(
                  width: double.infinity,
                  height: 120,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 200 / 60,
                    children: [
                      ...?carWash.additionalServices?.map(
                        (service) =>  Row(
                          children: [
                            SvgPicture.asset(
                                "${service == 'Ironing clothes' ? "assets/icons/vectorRight.svg" : service == 'Cafe' ? "assets/icons/vectorRight.svg" : service == 'Cashless Payment' ? "assets/icons/vectorRight.svg" : "assets/icons/vectorRight.svg"}"),
                            SizedBox(width: getProportionateScreenWidth(5)),
                            SizedBox(
                              width: 120,
                              child: Text(
                                service,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: getProportionateScreenWidth(18)),
                              ),
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),

      ],
    );
  }

  SizedBox buildPhotoCard() {
    return SizedBox(
      height: (SizeConfig.screenWidth - 160) / 2,
      width: (SizeConfig.screenWidth - 120) / 2,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white),
      ),
    );
  }
}
