import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/address_model.dart';
import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressesScreen extends StatefulWidget {
  static String routeName = "/addresses";

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  AuthProvider _auth = serviceLocator<AuthProvider>();
  List<String> _locations = [
    'Almaty',
    'Atyrau',
    'Aktobe',
    'Nursultan'
  ]; // Option 2
  List<String> _locations2 = [
    'Abay',
    'Tolebi',
    'Medey',
  ]; // Option 2
  String _selectedLocation = "Almaty"; // Option 2
  String _selectedLocation2 = "Abay"; // Option 2

  @override
  void initState() {
    fetchAddress();
    super.initState();
  }

  fetchAddress() async {
    DocumentSnapshot _snapshot = await FirebaseFirestore.instance
        .collection('address')
        .doc(_auth.currentUser!.id)
        .get();

    Address _address = Address.fromSnapshot(_snapshot);

    setState(() {
      _address.city != null ? _selectedLocation = _address.city! : null;
      _address.location != null
          ? _selectedLocation2 = _address.location!
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('address')
                .doc(_auth.currentUser!.id)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Address _address = Address.fromSnapshot(snapshot.data!);

                return SingleChildScrollView(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/address_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(40)),
                        child: Column(
                          children: [
                            SizedBox(
                              child:
                                  Image.asset('assets/images/illustration.png'),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(40),
                            ),
                            SizedBox(
                              child: Text(
                                'Select Your Location',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(26),
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(15),
                            ),
                            SizedBox(
                              child: Text(
                                'Swithch on your location to stay in tune with what’s happening in your area',
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF7C7C7C),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(80),
                            ),
                            ListTile(
                              title: Text("Your  city"),
                              subtitle: DropdownButton(
                                  hint: Text('Please choose a location'),
                                  // Not necessary for Option 1
                                  value: _selectedLocation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedLocation = newValue.toString();
                                    });
                                  },
                                  items: _locations.map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList()),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(30),
                            ),
                            ListTile(
                              title: Text("Your Area"),
                              subtitle: DropdownButton(
                                  hint: Text('Please choose a location'),
                                  // Not necessary for Option 1
                                  value: _selectedLocation2,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedLocation2 = newValue.toString();
                                    });
                                  },
                                  items: _locations2.map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList()),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(30),
                            ),
                            DefaultButton(
                              text: Text("Submit"),
                              press: () {
                                AuthProvider _auth =
                                    serviceLocator<AuthProvider>();
                                if (_selectedLocation.isNotEmpty &&
                                    _selectedLocation2.isNotEmpty) {
                                  _auth.currentUser != null
                                      ? FirebaseFirestore.instance
                                          .collection('address')
                                          .doc(_auth.currentUser!.id)
                                          .set({
                                          'city': _selectedLocation,
                                          'location': _selectedLocation2
                                        })
                                      : null;
                                } else {
                                  AlertProvider _alert =
                                      serviceLocator<AlertProvider>();
                                  _alert.showErrorMessage(context, "Fill empty",
                                      "Please fill maintain fields");
                                }
                              },
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      )),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              }
            }));
  }
}
