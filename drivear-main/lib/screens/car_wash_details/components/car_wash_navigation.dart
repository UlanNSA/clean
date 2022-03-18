import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/provider/info_window_model.dart';
import 'package:car_wash/screens/google_maps/GoogleMapsScreen.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CarWashNavigation extends StatelessWidget {
  final CarWash? carWash;

  const CarWashNavigation({Key? key, this.carWash}) : super(key: key);

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
                    SvgPicture.asset("assets/icons/place.svg"),
                    SizedBox(width: getProportionateScreenWidth(5)),
                    Text(
                      "ADDRESS",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: getProportionateScreenWidth(20)),
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Text(
                                "${carWash!.legalAddress ?? 'Not defined'}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: getProportionateScreenWidth(18)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    Row(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: getProportionateScreenWidth(5)),
                              Text(
                                "${carWash!.phone ?? 'Not defined'}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: getProportionateScreenWidth(18)),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        SizedBox(
          height: 500,
          width: double.infinity,
          child: ChangeNotifierProvider(
            create: (context) => InfoWindowModel(),
            child: GoogleMapsScreen(
              cameraPosition: LatLng(43.259321, 76.911274),
            ),
          ),
        )
      ],
    );
  }
}
