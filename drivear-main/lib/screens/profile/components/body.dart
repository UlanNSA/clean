import 'dart:developer';

import 'package:car_wash/components/ImageCapture.dart';
import 'package:car_wash/components/default_button.dart';
import 'package:car_wash/constans.dart';
import 'package:car_wash/models/user_model.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthProvider _auth = serviceLocator<AuthProvider>();
  final FireStorageProvider _storageProvider = serviceLocator<FireStorageProvider>();
  late UserModel _currentUser = _auth.currentUser != null ? _auth.currentUser! : UserModel();
  late TextEditingController _firstNameController = TextEditingController(text: _currentUser.firstName != null ? _currentUser.firstName : "");
  late TextEditingController _lastNameController = TextEditingController(text: _currentUser.lastName != null ? _currentUser.lastName : "");
  late TextEditingController _emailController = TextEditingController(text: _currentUser.email != null ? _currentUser.email : "");
  late TextEditingController _phoneController = TextEditingController(text: _currentUser.phone != null ? _currentUser.phone : "");
  String? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  loadProfileImage() async{
    profileImage = await _storageProvider.loadImage(context, '/images/', '${_currentUser.id}.png');
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(140),
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/profile_background.png'), fit: BoxFit.fill)
                        ),
                    ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 170,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _currentUser.id != null ? FutureBuilder(
                            future: _getProfileImage(context, '${_currentUser.id}.png'),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if(snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: snapshot.data,
                                        fit: BoxFit.fill
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.black,
                                  ),
                                  child: CircularProgressIndicator(color: kPrimaryColor,),
                                );
                              }
                              return Container();
                            },
                          ) : Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black,
                            ),
                            child: CircularProgressIndicator(color: kPrimaryColor,),
                          )
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        child: Text(
                          'CHANGE IMAGE',
                          style: TextStyle(
                              color: Color(0xFF0A1098),
                              fontWeight: FontWeight.w800,
                              fontSize: getProportionateScreenWidth(16)
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImageCapture())
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: double.infinity,
            child:Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              child: Column(
                children: [
                  buildTextFormField(hintText: 'Enter firstname', labelText: 'NAME', controller: _firstNameController),
                  SizedBox(height: 30,),
                  buildTextFormField(hintText: 'Enter lastname', labelText: 'LASTNAME', controller: _lastNameController),
                  SizedBox(height: 30,),
                  buildTextFormField(hintText: 'Enter email', labelText: 'EMAIL', controller: _emailController),
                  SizedBox(height: 30,),
                  buildTextFormField(hintText: 'Enter phone number', labelText: 'MOBILE NUMBER', controller: _phoneController, keyboardType: TextInputType.number),
                  SizedBox(height: 30,),
                  DefaultButton(
                    color: kPrimaryColor,
                    text: Text("Save"),
                    press: (){
                      final _newUser = UserModel(
                          id: _currentUser.id,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          displayName: _firstNameController.text + " " + _lastNameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          profileImageUrl: _currentUser.profileImageUrl
                      );
                      _auth.editProfile(context, _newUser);
                    },
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            )
          )
        ],
      ),
    );
  }

  Future<ImageProvider> _getProfileImage(BuildContext context, String imageName) async {
    ImageProvider? image;
    await _storageProvider.loadImage(context, '/images/', imageName).then((value) {
      try {
        image = NetworkImage(value);
      } catch (e) {
        log(e.toString());
      }
    }).onError((error, stackTrace) {
      image = Image.asset('assets/images/defaultProf.png').image;
    });

    return image!;
  }

  Row buildTextFormField({ hintText, required labelText, controller, keyboardType}) {
    return Row(
       crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth * 0.3,
            child: Text(
              labelText,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.5,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hintText,
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.red
                        )
                    )
                ),
            ),
          )
        ],
      );
  }
}

