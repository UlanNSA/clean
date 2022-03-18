import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/sign_up/sign_up_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:flutter/material.dart';

import './components/body.dart';

class OTPScreen extends StatefulWidget {
  static String routeName = "/otp";
  final String? phoneNumber;

  const OTPScreen({Key? key, this.phoneNumber}) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _codeController = TextEditingController();
  final AuthProvider? _authProvider = serviceLocator<AuthProvider>();
  @override
  void initState() {
    super.initState();
    _authProvider!.verifyPhoneNumber(context, widget.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(formKey: _formKey, codeController: _codeController,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        backgroundColor: Colors.green,
        onPressed: (){
          if(_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            _authProvider!.checkSmsCode(context, _codeController.text);
          }
        },
      ),
    );
  }
}
