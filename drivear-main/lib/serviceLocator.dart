import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/provider/car_wash_provider.dart';
import 'package:car_wash/provider/fire_storage_provider.dart';
import 'package:car_wash/provider/loading_provider.dart';
import 'package:car_wash/provider/orders_provider.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void serviceLocatorSetup() {
  serviceLocator
    ..registerSingleton<AlertProvider>(AlertProvider())
    ..registerSingleton<LoadingProvider>(LoadingProvider())
    ..registerSingleton<AuthProvider>(AuthProvider())
    ..registerSingleton<FireStorageProvider>(FireStorageProvider())
    ..registerSingleton<CarWashProvider>(CarWashProvider())
    ..registerSingleton<OrdersProvider>(OrdersProvider());
}
