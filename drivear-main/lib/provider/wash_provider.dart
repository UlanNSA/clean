
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:flutter/cupertino.dart';

class WashProvider with ChangeNotifier{
  List<Wash>? _carWashs = [];

  List<Wash>? get carWashs => _carWashs;

  void addCarWash(Wash carWash) => FirebaseApi.createCarWash(carWash);

  void setCarWashs(List<Wash>? carWashs) =>
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _carWashs = carWashs;
      });
}