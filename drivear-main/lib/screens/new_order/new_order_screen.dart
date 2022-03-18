import 'dart:developer';

import 'package:car_wash/assets.dart';
import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/models/order_model.dart';
import 'package:car_wash/models/orders_response_model.dart';
import 'package:car_wash/models/select_option.dart';
import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/orders_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class NewOrderScreen extends StatefulWidget {
  final CarWash carWash;
  static String routeName = '/new-order';


  const NewOrderScreen({Key? key, required this.carWash}) : super(key: key);

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final AlertProvider _alertProvider = serviceLocator<AlertProvider>();
  final AuthProvider _authProvider = serviceLocator<AuthProvider>();
  DateTime? currentDate;
  TimeOfDay? selectedTime;
  List<CarWashService> selectedServices = [];
  List<String> carTypes = ['House', 'Flat', 'Room'];
  List<String> serviceType = ['Econom', 'Premium', 'Bisness', 'Lux'];
  int total = 0;
  int optinonalCost = 0;
  String? selectedCarType;
  String? selectedServiceType;
  String? label;

  void onCarTypeSelect(newValue) {
    String _selectedCarType = selectedCarType ?? '';
    log((carTypes.indexOf(_selectedCarType) * 500).toString());
    setState(() {
      total -= carTypes.indexOf(_selectedCarType) == -1 ? 0 : carTypes.indexOf(_selectedCarType) * 500;
      selectedCarType = newValue;
      total += carTypes.indexOf(newValue) * 500;
    });
  }

  void onServiceTypeSelect(newValue) {
    setState(() {
      selectedServiceType = newValue;
      total = total - optinonalCost;
      optinonalCost = serviceType.indexOf(newValue) * 500;
      total = total + optinonalCost;
    });
  }

  void addOrRemove(CarWashService service) {
    if (selectedServices.contains(service)) {
      setState(() {
        selectedServices.remove(service);
      });
    } else {
      setState(() {
        selectedServices.add(service);
      });
    }
    total = selectedServices.fold(
        0, (previousValue, element) => previousValue + element.price!);

  }

  @override
  Widget build(BuildContext context) {
    OrdersProvider _ordersProvider = serviceLocator<OrdersProvider>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            'Registration for the sink',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
        body: SizedBox(
            height: 1000,
            width: double.infinity,
            child: Container(
                height: 1000,
                decoration: BoxDecoration(
                  color: Color(0xFFE0E8E2),
                  image: DecorationImage(
                    image: AssetImage("assets/images/order_bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView(
                            shrinkWrap: true,
                            children: widget.carWash.services!.map((element) {
                              return ListTile(
                                leading: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: kPrimaryColor,
                                  value: selectedServices.contains(element),
                                  onChanged: (bool? value) {
                                    addOrRemove(element);
                                  },
                                ),
                                title: Text('${element.name}'),
                                trailing: Text('${element.price}tg'),
                              );
                            }).toList(),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        text: Text('Choose Time'),
                        color: kLightBlueColor,
                        press: () {
                          _selectDate(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      currentDate != null ? Text('${DateFormat('yyyy-MM-dd').format(currentDate!)}') : Container(),
                      selectedTime != null ? Text('${selectedTime!.format(context)}') : Container(),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    SizedBox(width: 16),
                                    ...carTypes.map((bodyType) => SelectOption<String>(
                                      label: bodyType,
                                      value: bodyType,
                                      leading: SvgPicture.asset(
                                        BodyTypeIconAssets.getBodyTypeAssetByName(bodyType),
                                      ),
                                    ))
                                        .toList().map((bodyType) {
                                      final isSelected = selectedCarType == bodyType.value;
                                      final label = bodyType.label!;
                                      final backgroundColor = isSelected ? kPrimaryColor : Colors.white;
                                      final textColor = isSelected ? Colors.white : kPrimaryColor;
                                      final border = isSelected ? Border.all(color: kPrimaryColor, width: 1) : null;

                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.07),
                                                offset: Offset(0.0, 5.0), //(x,y)
                                                blurRadius: 12.0,
                                                spreadRadius: 5.0,
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: border,
                                                ),
                                                height: 62,
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 4),
                                                    SizedBox(height: 16, width: 62, child: bodyType.leading),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      label,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () => {
                                                onCarTypeSelect(bodyType.value)
                                              } ,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                )),
                            ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                                height: 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    SizedBox(width: 16),
                                    ...serviceType.map((bodyType) => SelectOption<String>(
                                      label: bodyType,
                                      value: bodyType,
                                      leading: SvgPicture.asset(
                                        BodyTypeIconAssets.getBodyTypeAssetByName(bodyType),
                                      ),
                                    ))
                                        .toList().map((bodyType) {
                                      final isSelected = selectedServiceType == bodyType.value;
                                      final label = bodyType.label!;
                                      final backgroundColor = isSelected ? kPrimaryColor : Colors.white;
                                      final textColor = isSelected ? Colors.white : kPrimaryColor;
                                      final border = isSelected ? Border.all(color: kPrimaryColor, width: 1) : null;

                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.07),
                                                offset: Offset(0.0, 5.0), //(x,y)
                                                blurRadius: 12.0,
                                                spreadRadius: 5.0,
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: border,
                                                ),
                                                height: 62,
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 4),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      label,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () => {
                                                onServiceTypeSelect(bodyType.value)
                                              } ,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        'TOTAL : $total tg',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w300),
                      ),
                      Spacer(),
                      DefaultButton(
                        text: Text('Make Order'),
                        color: kPrimaryColor,
                        press: () {
                          if (selectedServices.isEmpty) {
                            _alertProvider.showErrorMessage(
                                context,
                                "Please select services",
                                "Services not selected");
                          } else if (currentDate == null){
                            _alertProvider.showErrorMessage(
                                context,
                                "Please select Date",
                                "Date not selected");
                          } else if (selectedCarType == null){
                            _alertProvider.showErrorMessage(
                                context,
                                "Please select car type",
                                "Car type not selected");
                          } else if (selectedServiceType == null){
                            _alertProvider.showErrorMessage(
                                context,
                                "Please select car service type",
                                "Car service type not selected");
                          } else {
                            _ordersProvider.makeOrder(
                                context,
                                Order(
                                    userid: _authProvider.currentUser!.id,
                                    services: selectedServices,
                                    date: currentDate,
                                    time: selectedTime,
                                    carType: selectedCarType,
                                    serviceType: selectedServiceType,
                                    price: total,
                                    carWashName: widget.carWash));
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ))));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        currentDate = pickedDate;
      });

      List<Order>? rentedTime = await _fetchOpenedTime(context);

      int initialTime = 0;
      List<int?> rentedTimes = rentedTime != null
          ? rentedTime
              .where((element) => element.date!.compareTo(pickedDate) == 0)
              .map((e) {
              return e.time!.hour;
            }).toList()
          : [];

      while (rentedTimes.contains(initialTime) || initialTime < 9) {
        initialTime++;
      }

      showCustomTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initialTime, minute: 0),
        onFailValidation: (context) => print('Unavailable selection'),
        selectableTimePredicate: (time) => rentedTimes.contains(time.hour) == false && time.hour >= 9 && time.hour <= 19,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
      ).then((value) => {
            if (value != null)
              {
                setState(() {
                  selectedTime = value;
                })
              }
          });
    }
  }

  Future<List<Order>?> _fetchOpenedTime(BuildContext context) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('carwash_orders')
        .doc(widget.carWash.id);
    DocumentSnapshot? docSnap = await docRef.get();

    OrderResponse _response = docSnap.data() == null
        ? OrderResponse(orders: [])
        : OrderResponse.fromSnapshot(docSnap);

    return _response.orders;
  }
}