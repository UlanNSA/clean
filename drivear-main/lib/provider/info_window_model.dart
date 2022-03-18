import 'dart:io';

import 'package:car_wash/models/car_wash_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoWindowModel extends ChangeNotifier {
  bool _showInfoWindow = false;
  bool _tempHidden = false;
  CarWash? _carWash;
  double? _leftMargin;
  double? _topMargin;

  void rebuildInfowindow() {
    notifyListeners();
  }

  void updateCarWash(CarWash carWash) {
    _carWash = carWash;
  }

  void updateVisibility(bool visibility) {
    _showInfoWindow = visibility;
  }

  void updateInfowindow(
      BuildContext context,
      GoogleMapController controller,
      LatLng location,
      double infoWindowWidth,
      double marketOffset,
  ) async {
    ScreenCoordinate screenCoordinate = await controller.getScreenCoordinate(location);
    double devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) - (infoWindowWidth / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) - marketOffset;

    if ( left < 0 || top < 0 ) {
      _tempHidden = true;
      _leftMargin = 0;
      _topMargin = 0;
    } else {
      _tempHidden = false;
      _leftMargin = left;
      _topMargin = top;
    }
  }

  bool get showInfoWindow => (_showInfoWindow == true && _tempHidden == false) ? true : false;

  double? get leftMargin => _leftMargin;

  double? get topMargin => _topMargin;

  CarWash? get carWash => _carWash;
}