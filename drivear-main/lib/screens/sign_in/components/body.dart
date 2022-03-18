import 'package:car_wash/components/CircularButton.dart';
import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/sign_up/sign_up_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:car_wash/screens/otp/otp_screen.dart';

class Body extends StatefulWidget {
  final formKey;
  final TextEditingController? phoneController;
  final Function setEmail;
  final Function setPassword;
  final Function setPhone;
  final Function setStep;

  final bool step;
  const Body({
    Key? key,
    this.formKey,
    this.phoneController,
    required this.setEmail,
    required this.setPassword,
    required this.step,
    required this.setStep,
    required this.setPhone
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? _phone;
  String? _country = "+7";
  List<String> errors = [];


  final AuthProvider? _authProvider = serviceLocator<AuthProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authProvider!.checkIsLoggedIn(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                "assets/images/sign_up_image.png",
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: Text(
                        "Welcome to LIN",
                        style: TextStyle(
                          color: Color(0xFF030303),
                          fontSize: getProportionateScreenWidth(26),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  // buildPhoneField(),
                  Column(
                    children: [
                      widget.step ? buildEmailField() : Container(),
                      widget.step ? buildPasswordField() : Container(),
                      !widget.step ? buildPhoneField() : Container(),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.setStep(!widget.step);
                          });
                        },
                        child: Text(
                            widget.step ? 'Использовать телефон' : 'Использовать почту'
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    child: GestureDetector(
                      onTap: (){
                        // resend your OTP
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Text(
                        "Don't have an account? Register",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(15)
                        ),

                      ),
                    ),
                  ),

                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile buildPasswordField() {
    return ListTile(
      leading: Icon(Icons.lock),
      title: TextFormField(
        obscureText: true,
        onSaved: (value) => widget.setPassword(value!),
        onChanged: (value) {
          if (value.isNotEmpty) {
          } else {
            setState(() {
              widget.setPassword(value);
            });
          }

          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Заполните поле";
          }
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.left,
      ),
    );
  }

  ListTile buildEmailField() {
    return ListTile(
      leading: Icon(Icons.email),
      title: TextFormField(
        onSaved: (value) => widget.setEmail(value!),
        onChanged: (value) {
          if (value.isNotEmpty) {
          } else {
            setState(() {
              widget.setEmail(value);
            });
          }

          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Заполните поле";
          } else if (!emailRegExp.hasMatch(value)) {
            return 'Введите почту правильно';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget buildPhoneField() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Color(0xFFE2E2E2), width: 1))),
        child: Row(
          children: [
            CountryCodePicker(
              onChanged: (value) => _country = value.dialCode,
              initialSelection: 'KZ',
              textStyle: TextStyle(fontSize: 24),
            ),
            SizedBox(
              width: getProportionateScreenWidth(230),
              child: TextFormField(
                controller: widget.phoneController,
                onSaved: (value) => widget.setPhone('$_country $value'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                  } else {
                    setState(() {
                      widget.setPhone('$_country $value');
                    });
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Заполните поле";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}