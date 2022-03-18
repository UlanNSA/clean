import 'package:flutter/cupertino.dart';

class LoadingProvider with ChangeNotifier {
  bool isLoading = false;

  LoadingProvider() {
    isLoading = false;
  }

}