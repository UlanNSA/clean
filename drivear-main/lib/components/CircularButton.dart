import 'package:flutter/material.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    Key? key,
    required this.icon,
    required this.onClick,
    this.color,
  }) : super(key: key);
  final String icon;
  final Function onClick;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick as void Function()?,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        height: getProportionateScreenHeight(50),
        width: getProportionateScreenWidth(50),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(
            icon,
          ),
        ),
      ),
    );
  }
}
