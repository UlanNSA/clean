import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/loading_provider.dart';
import 'package:car_wash/screens/sign_in/components/body.dart';
import 'package:car_wash/screens/otp/otp_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthProvider? _authProvider = serviceLocator<AuthProvider>();
  final LoadingProvider? _loadingProvider = serviceLocator<LoadingProvider>();
  bool step = true;

  String _email = "";
  String _password = "";
  String _phone = "";

  void setEmail(value) {
    _email = value;
  }

  void setPassword(value) {
    _password = value;
  }

  void setPhone(value) {
    _phone = value;
  }

  void setStep(value) {
    setState(() {
      step = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(
        formKey: _formKey,
        setEmail: setEmail,
        setPassword: setPassword,
        setPhone: setPhone,
        setStep: setStep,
        step: step,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        backgroundColor: Colors.green,
        onPressed: (){
          if(_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            step ? _authProvider!.signInWithEmail(context, _email, _password) : _authProvider!.verifyPhoneNumber(context, '+7 778 911 3039');
          }
        },
      ),
    );
  }
}