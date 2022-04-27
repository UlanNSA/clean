import 'dart:developer';

import 'package:car_wash/components/default_bottom_navigator.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/network/FirebaseApi.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/provider/info_window_model.dart';
import 'package:car_wash/screens/favourite/favourite_screen.dart';
import 'package:car_wash/screens/main/main_screen.dart';
import 'package:car_wash/screens/profile/profile_screen.dart';
import 'package:car_wash/screens/search_screen/search_screen.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  final int? selectedIndex;

  const HomeScreen({Key? key, this.selectedIndex = 0}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    StreamBuilder<List<Wash>>(
        stream: FirebaseApi.readCarWashs(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(color: kPrimaryColor,));
            default:
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Text('Something Went Wrong Try later');
              } else {
                final todos = snapshot.data;

                final provider = Provider.of<WashProvider>(context);
                provider.setCarWashs(todos);

                return  ChangeNotifierProvider(
                    create: (context) => InfoWindowModel(),
                    child: MainScreen());
              }
          }
        },
      ),
    FavouriteScreen(),
    SearchScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.selectedIndex ?? 0;
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: DefaultBottomNavigator(selectedIndex: _selectedIndex, onItemTap: _onItemTap,),
    );
  }


}
