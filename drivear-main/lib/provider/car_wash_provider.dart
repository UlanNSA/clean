
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:flutter/cupertino.dart';

class CarWashProvider with ChangeNotifier{
  List<CarWash>? _carWashs = [];

  List<CarWash>? get carWashs => _carWashs;

  void addCarWash(CarWash carWash) => FirebaseApi.createCarWash(carWash);

  void setCarWashs(List<CarWash>? carWashs) =>
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _carWashs = carWashs;
      });
}