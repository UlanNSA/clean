import 'package:flutter/material.dart';

import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.color,
    this.height,
  }) : super(key: key);
  final Text? text;
  final Function? press;
  final Color? color;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(height ?? 56),
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: color,
          onPressed: press as void Function()?,
          child: text!),
    );
  }
}
