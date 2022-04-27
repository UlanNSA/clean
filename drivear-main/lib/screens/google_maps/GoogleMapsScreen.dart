import 'dart:developer';
import 'dart:io';

import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/provider/info_window_model.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleMapsScreen extends StatefulWidget {
  final LatLng cameraPosition;
  const GoogleMapsScreen({Key? key, required this.cameraPosition})
      : super(key: key);
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late GoogleMapController mapController;

  BitmapDescriptor? mapMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  Future<void> setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/icons/place.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WashProvider>(context);
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);
    final Set<Marker> _markers = {};
    var _carWashList = [];
    if (provider.carWashs != null) {
      _carWashList = provider.carWashs!;
    }
    _carWashList.forEach((element) {
      _markers.add(Marker(
          markerId: MarkerId(element.name!),
          position: element.location!,
          icon: mapMarker ?? BitmapDescriptor.defaultMarker,
          onTap: () {
            providerObject.updateInfowindow(context, mapController,
                element.location!, _infoWindowWidth, _markerOffset);
            providerObject.updateCarWash(element);
            providerObject.updateVisibility(true);
            providerObject.rebuildInfowindow();
          }));
    });

    log(_markers.toString());
    return Container(
      child: Consumer<InfoWindowModel>(
          builder: (context, model, child) {
            return Stack(
              children: [
                child!,
                Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Visibility(
                      visible: providerObject.showInfoWindow,
                      child: (providerObject.carWash == null ||
                              !providerObject.showInfoWindow)
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(
                                  left: providerObject.leftMargin != null &&
                                          providerObject.leftMargin!.isNegative
                                      ? providerObject.leftMargin!
                                      : 0,
                                  top: providerObject.topMargin != null &&
                                          providerObject.topMargin!.isNegative
                                      ? providerObject.topMargin!
                                      : 0),
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Color(0xfffceef5)
                                              ],
                                              end: Alignment.bottomCenter,
                                              begin: Alignment.topCenter),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0),
                                                blurRadius: 6.0)
                                          ]),
                                      width: getProportionateScreenWidth(300),
                                      padding: EdgeInsets.all(15),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    providerObject
                                                        .carWash!.name!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                15),
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenWidth(
                                                      10),
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/local_offer.svg",
                                                  height:
                                                      getProportionateScreenWidth(
                                                          12),
                                                  width:
                                                      getProportionateScreenWidth(
                                                          12),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  "${providerObject.carWash!.avgPrice}tg",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenWidth(
                                                      10),
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/alarm.svg",
                                                  height:
                                                      getProportionateScreenWidth(
                                                          12),
                                                  width:
                                                      getProportionateScreenWidth(
                                                          12),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  "11:00",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  "13:00",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  "15:00",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  "17:00",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenWidth(
                                                      10),
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/place.svg",
                                                  height:
                                                      getProportionateScreenWidth(
                                                          12),
                                                  width:
                                                      getProportionateScreenWidth(
                                                          12),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                Text(
                                                  'Address',
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenWidth(
                                                      20),
                                            ),
                                            DefaultButton(
                                              text: Text(
                                                "MORE",
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            18),
                                                    color: Colors.white),
                                              ),
                                              height: 30,
                                              color: kPrimaryColor,
                                              press: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WashDetail(
                                                              carWash:
                                                                  providerObject
                                                                      .carWash!)),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                    ))
              ],
            );
          },
          child: Stack(
            children: [
              Positioned(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: widget.cameraPosition, zoom: 15),
                ),
              ),
              if (Platform.isIOS)
                Positioned(
                  bottom: 80,
                    right: 8,
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        zoomIn();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, offset: Offset.fromDirection(0.5))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(Icons.zoom_in, size: 30,),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        zoomOut();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, offset: Offset.fromDirection(0.5))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(Icons.zoom_out, size: 30,),
                      ),
                    )
                  ],
                )),
            ],
          )),
    );
  }

  void zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  void zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }
}
