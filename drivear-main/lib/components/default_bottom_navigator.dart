import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constans.dart';
import '../size_config.dart';

class DefaultBottomNavigator extends StatefulWidget {
  final Function onItemTap;
  final int selectedIndex;

  const DefaultBottomNavigator(
      {Key? key, required this.onItemTap, required this.selectedIndex})
      : super(key: key);
  @override
  _DefaultBottomNavigatorState createState() => _DefaultBottomNavigatorState();
}

class _DefaultBottomNavigatorState extends State<DefaultBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      child: SizedBox(
        height: getProportionateScreenHeight(80),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/store.svg",
                  width: getProportionateScreenWidth(20),
                ),
                label: "Catalog",
                backgroundColor: kPrimaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/favorite.svg",
                  width: getProportionateScreenWidth(20),
                ),
                label: "Favorite",
                backgroundColor: kPrimaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  height: getProportionateScreenWidth(20),
                ),
                label: "Search",
                backgroundColor: kPrimaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/profile.svg",
                  width: getProportionateScreenWidth(18),
                ),
                label: "Profile",
                backgroundColor: kPrimaryColor),
          ],
          currentIndex: widget.selectedIndex,
          onTap: widget.onItemTap as void Function(int)?,
        ),
      ),
    );
  }
}
