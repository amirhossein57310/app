import 'package:dio/dio.dart';
import 'package:hess_app/util/auth_manager.dart';

abstract class IauthenticationDataSource {
  Future<void> verifing(String? mobile, String? email, String firstname,
      String lastname, String code);
  Future<void> secondVerifing(String? mobile, String? email, String? firstname,
      String? lastname, String code);

  Future<String> login(String? mobile, String? email);
}

class Authentication extends IauthenticationDataSource {
  final Dio _dio;
  Authentication(this._dio);

  @override
  Future<void> verifing(String? mobile, String? email, String firstname,
      String lastname, String code) async {
    try {
      var response = await _dio.post(
        'verifying',
        data: {
          'mobile': mobile ?? null,
          'email': email ?? null,
          'firstname': firstname,
          'lastname': lastname,
          'code': code,
        },
      );
      // if (response.statusCode == 200) {
      //   login(username, password);
      // }
      //  if (response.statusCode == 200) {
      //   login(mobile, email);
      // }
      AuthManager.saveToken(response.data['data']['userToken']);
      print(response.data['data']['userToken']);
      return response.data['data']['userToken'];
    } on DioException catch (ex) {
      throw ex;
    }
  }

  @override
  Future<String> login(String? mobile, String? email) async {
    try {
      var response = await _dio.post('signing', data: {
        'mobile': mobile ?? null,
        'email': email ?? null,
      });
      if (response.data['statusCode'] == 200) {
        AuthManager.saveActionCode(response.data['data']['actionCode']);

        //AuthManager.saveId(response.data['record']['id']);

        //  AuthManager.saveToken(response.data['token']);

        return response.data['data']['actionCode'];
      }
    } on DioException catch (ex) {
      throw ex;
      // } catch (ex) {
      //   throw ApiException(0, 'unknown error');
      // }
    }
    return '';
  }

  @override
  Future<void> secondVerifing(String? mobile, String? email, String? firstname,
      String? lastname, String code) async {
    try {
      var response = await _dio.post(
        'verifying',
        data: {
          'mobile': mobile ?? null,
          'email': email ?? null,
          'firstname': firstname ?? null,
          'lastname': lastname ?? null,
          'code': code,
        },
      );
      // if (response.statusCode == 200) {
      //   login(username, password);
      // }
      //  if (response.statusCode == 200) {
      //   login(mobile, email);
      // }
      AuthManager.saveToken(response.data['data']['userToken']);
      print(response.data['data']['userToken']);
      return response.data['data']['userToken'];
    } on DioException catch (ex) {
      throw ex;
    }
  }
}
