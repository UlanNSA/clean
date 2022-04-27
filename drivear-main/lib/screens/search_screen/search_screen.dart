import 'dart:developer';

import 'package:car_wash/components/default_drawer.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/screens/car_wash_details/wash_detail.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FireStorageProvider _storageProvider = serviceLocator<FireStorageProvider>();
  final TextEditingController searchController = TextEditingController();
  List<Wash> filteredCarWashList = [];
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WashProvider>(context);
    final _carWashList = provider.carWashs!;

    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          height: double.infinity,
          child: AppBar(
            toolbarHeight: double.infinity,
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Text('Favourite', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
                      child: TextField(
                        // controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchValue = value;
                            filteredCarWashList = _carWashList
                                .where(
                                    (element) =>
                                        element.name!.toLowerCase().contains(value.toLowerCase())
                            ).toList();
                          });
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.search),
                            fillColor: Colors.white,
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            hintText: 'Search Cleaning'
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: buildDrawer(context: context),
      body: ListView.builder(
        itemCount: searchValue.length > 0 ? filteredCarWashList.length :  _carWashList.length,
        itemBuilder: (context, index) {
          final _list = searchValue.length > 0 ? filteredCarWashList :  _carWashList;
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    WashDetail(carWash: _list[index])),
              );
            },
            leading: FutureBuilder(
              future: _getProfileImage(context, '${_list[index].id}.png'),
              builder: (BuildContext context,
                  AsyncSnapshot<ImageProvider<Object>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: snapshot.data == null ? Image.asset('assets/images/spray.png').image : snapshot.data!,
                            fit: BoxFit.cover
                        )
                    ),
                  );
                } else {
                  return CircularProgressIndicator(color: kPrimaryColor,);
                }
              },
            ),
            title: Text(
              '${_list[index].name}',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('3km, Price'),
            trailing: SizedBox(
              width: 70,
              child: Row(
                children: [
                  Text('${_list[index].avgPrice} tg'),
                  Spacer(),
                  SvgPicture.asset("assets/icons/VectorRightBlack.svg")
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<ImageProvider> _getProfileImage(BuildContext context, String imageName) async {
    ImageProvider? image;
    await _storageProvider.loadImage(context, '/images/car_washs/', imageName).then((value) {
      try {
        image = NetworkImage(value);
      } catch (e) {
        log(e.toString());
      }
    });

    return image!;
  }
}
