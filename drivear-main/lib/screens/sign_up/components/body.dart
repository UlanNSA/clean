import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final GlobalKey<FormState>? formKey;

  const Body({Key? key, this.formKey}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final AuthProvider? _authProvider = serviceLocator<AuthProvider>();
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
              SizedBox(height: getProportionateScreenWidth(60)),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(15)),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter your credentials to continue',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7C7C7C)
                    ),
                  ),
                ),
              ),
            SizedBox(height: getProportionateScreenWidth(40)),
            signUpForm(),
            SizedBox(height: getProportionateScreenWidth(20)),
            SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'By continuing you agree to our ',
                    style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service\n',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: 'and ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  )
                ),
              ),
            ),

            SizedBox(height: getProportionateScreenWidth(30)),
            DefaultButton(
              text: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300
                ),
              ),
              color: kPrimaryColor,
              height: 65,
              press: (){
                if(widget.formKey!.currentState!.validate()) {
                  _authProvider!.signUpWithEmail(context, emailController.text, passwordController.text, usernameController.text);
                }
              },
            ),
            SizedBox(height: getProportionateScreenWidth(25)),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xFF7C7C7C),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 14,
                            ),
                          )
                        ]
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Form signUpForm() {
    return Form(
            key: widget.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Заполните поле";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Color(0xFF030303),
                    fontWeight: FontWeight.w300
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    hintStyle: TextStyle(
                        color: Color(0x7C7C7C7C),
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w300
                    ),
                    labelText: "Username",
                    labelStyle: TextStyle(
                      color: Color(0x7C7C7C7C),
                      fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.w300
                    )
                  ),
                ),
                SizedBox(height: getProportionateScreenWidth(30)),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Заполните поле";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Color(0xFF030303)
                  ),
                  decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(
                          color: Color(0x7C7C7C7C),
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w300
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                          color: Color(0x7C7C7C7C),
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w300
                      )
                  ),
                ),
                SizedBox(height: getProportionateScreenWidth(30)),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Заполните поле";
                    }
                    return null;
                  },
                  obscureText: true,
                  style: TextStyle(
                      color: Color(0xFF030303),
                  ),
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: TextStyle(
                          color: Color(0x7C7C7C7C),
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w300
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                          color: Color(0x7C7C7C7C),
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w300
                      )
                  ),
                )
              ],
            ),
          );
  }
}
