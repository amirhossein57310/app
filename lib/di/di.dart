import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hess_app/data/daasource/auth_datasource.dart';
import 'package:hess_app/data/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;
Future<void> getItInit() async {
  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: 'https://api.hesetazegi.com/api/User/')));
  locator.registerFactory<IauthenticationDataSource>(() {
    return Authentication(locator.get());
  });
  locator.registerSingleton<IAuthenticationRepositories>(
      AuthenticationRepositories(locator.get()));
}
