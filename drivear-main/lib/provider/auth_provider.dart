import 'dart:developer';

import 'package:car_wash/models/favourite_carwash.dart';
import 'package:car_wash/models/user_model.dart';
import 'package:car_wash/models/message_model.dart';
import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/provider/loading_provider.dart';
import 'package:car_wash/screens/home/home_screen.dart';
import 'package:car_wash/screens/otp/otp_screen.dart';
import 'package:car_wash/screens/sign_up/sign_up_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  static const LOGGED_IN = 'loggedIn';
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _storage = FirebaseFirestore.instance;
  late LoadingProvider? _loadingProvider = serviceLocator<LoadingProvider>();
  late AlertProvider? _alertProvider = serviceLocator<AlertProvider>();
  String? _verificationCode;
  User? _user;
  UserModel? _currentUserData;
  Status _status = Status.Uninitialized;

  String? get verificationCode => _verificationCode;

  User? get user => _user;

  UserModel? get currentUser => _currentUserData;

  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.accessToken != null) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      UserCredential _user = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      saveUserToDB(context, _user.user!);

      Navigator.pushNamed(context, HomeScreen.routeName);
      return _user;
    } else {
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential _user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      saveUserToDB(context, _user.user!);

      Navigator.pushNamed(context, HomeScreen.routeName);
      return _user;
    } else {
      return null;
    }
  }

  Future<void> checkIsLoggedIn(BuildContext context) async {
    if (_auth.currentUser != null) {
      final _u =
          await _storage.collection('users').doc(_auth.currentUser!.uid).get();
      _currentUserData = UserModel.fromSnapshot(_u);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => true);
    } else {}
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      _loadingProvider!.isLoading = true;
      UserCredential _user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .onError((error, stackTrace) => _alertProvider!
              .showErrorMessage(context, "Sign in error", error.toString()));

      await saveUserToDB(context, _user.user!);

      _loadingProvider!.isLoading = false;
      Navigator.pushNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> saveUserToDB(BuildContext context, User user) async {
    if (user != null) {
      log("TEST ${user.toString()}");
      _currentUserData = UserModel.fromSnapshot(
          await _storage.collection('users').doc(user.uid).get());
    } else {
      _alertProvider!
          .showErrorMessage(context, "Something go wrong", "Try again");
    }
  }

  Future<void> likeOrUnlikeCarwash(String id) async {
    DocumentReference docRef =
        _storage.collection('favourites').doc(_currentUserData!.id);
    DocumentSnapshot? docSnap = await docRef.get();
    FavouriteCarwashList? list = FavouriteCarwashList.fromSnapshot(docSnap);
    // list.list = list.list != null ? list.list : <FavouriteCarwash>[];
    int index = list.list!.length > 0
        ? list.list!.indexWhere((element) => element.id == id)
        : -1;
    log(index.toString());
    if (index != -1) {
      FavouriteCarwash current = list.list![index];
      list.list![index] =
          FavouriteCarwash(id: id, likeOrDislike: !current.likeOrDislike!);
    } else {
      list.list!.add(FavouriteCarwash(id: id, likeOrDislike: true));
    }
    docRef.set(list.toJson());
  }

  Future<void> comment(MessageModel message) async {
    DocumentReference docRef = _storage.collection('comments').doc(message.to);
    DocumentSnapshot? docSnap = await docRef.get();
    CommentsCarwashList? list = CommentsCarwashList.fromSnapshot(docSnap);
    list.list!.add(message);
    docRef.set(list.toJson());
  }

  Future<void> editProfile(BuildContext context, UserModel userModel) async {
    log(userModel.toString());
    _storage.collection('users').doc(userModel.id).set(userModel.toJson());
    _currentUserData = userModel;
    _alertProvider!
        .showSuccessMessage(context, "Profile Edit", "Successfully Edited");
  }

  Future<void> signUpWithEmail(BuildContext context, String email,
      String password, String username) async {
    log(email + ' ' + password);
    try {
      UserCredential _user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      log(_user.toString());

      UserModel currentUser = UserModel.fromCredentials(_user.user!);
      currentUser.displayName = username;
      _storage
          .collection('users')
          .doc(_user.user!.uid)
          .set(currentUser.toJson());
      _alertProvider!
          .showSuccessMessage(context, "Success", "Registration Successfull")
          .then((value) {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _alertProvider!.showErrorMessage(
            context, "Error", 'The password provided is too weak.');
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _alertProvider!.showErrorMessage(
            context, "Error", 'The account already exists for that email.');
        log('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    _loadingProvider!.isLoading = true;
    log(number);
    _auth.verifyPhoneNumber(
        phoneNumber: '$number',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              saveUserToDB(context, value.user!);
              Navigator.pushNamed(context, HomeScreen.routeName);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          log('VERIFICATION FAILED ${e.code}');
          _loadingProvider!.isLoading = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          _loadingProvider!.isLoading = false;
          _verificationCode = verificationId;
          log('codeSent ${verificationCode}');

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(
                      phoneNumber: number,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _loadingProvider!.isLoading = false;
          _verificationCode = verificationId;
        });
  }

  Future<void> checkSmsCode(BuildContext context, String smsCode) async {
    try {
      await _auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationCode!, smsCode: smsCode)).then((value) {
        if (value.user != null) {
          saveUserToDB(context, value.user!);
          Navigator.pushNamed(context, HomeScreen.routeName);
        }
      });
    } catch (e) {
      _alertProvider!
          .showErrorMessage(context, "Something Go wrong!", "Try again");
    }
  }
}
