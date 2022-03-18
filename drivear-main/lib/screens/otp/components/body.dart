import 'package:car_wash/components/CircularButton.dart';
import 'package:car_wash/size_config.dart';
import 'package:car_wash/constans.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final formKey;
  final TextEditingController? codeController;
  const Body({Key? key, this.formKey, this.codeController}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 30));
    animation = Tween<double>(begin: 30, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backShadowImage.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CircularButton(
                      icon: "assets/icons/vectorLeft.svg",
                      onClick: () {
                        Navigator.pop(context);
                      },
                      color: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(70),),
                SizedBox(
                  width: double.infinity,
                  child: Text("Enter your 6-digit code",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(26),
                          fontWeight: FontWeight.w300)),
                ),
                OTPForm(),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: (){
                        // resend your OTP
                        if (animation.value == 0) {
                          controller.reset();
                          controller.forward();
                        }
                      },
                      child: Text(
                        "Resend Code (${animation.value.toInt()})",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(15)
                        ),
                        
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget OTPForm() {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget.codeController,
            autofocus: true,
            validator: (value) {
              if (value!.isEmpty){
                return "Заполните поле";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "- - - - - -",
                hintStyle: TextStyle(fontSize: getProportionateScreenWidth(18)),
                labelText: "Code",
                labelStyle: TextStyle(
                    color: Color(0x7C7C7C7C),
                    fontSize: getProportionateScreenWidth(24))),
          )
        ],
      ),
    );
  }
}

