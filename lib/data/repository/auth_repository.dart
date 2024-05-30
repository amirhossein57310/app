import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hess_app/data/daasource/auth_datasource.dart';

abstract class IAuthenticationRepositories {
  Future<Either<String, String>> verifing(String? mobile, String? email,
      String firstname, String lastname, String code);

  Future<Either<String, String>> login(String? mobile, String? email);
}

class AuthenticationRepositories extends IAuthenticationRepositories {
  final IauthenticationDataSource _datasource;
  AuthenticationRepositories(this._datasource);

  @override
  Future<Either<String, String>> verifing(String? mobile, String? email,
      String firstname, String lastname, String code) async {
    try {
      await _datasource.verifing(mobile, email, firstname, lastname, code);
      return right('ثبت نام با موفقیت انجام شد');
    } on DioException catch (ex) {
      return left(ex.message!);
    }
  }

  @override
  Future<Either<String, String>> login(String? mobile, String? email) async {
    try {
      String actionCode = await _datasource.login(mobile, email);
      if (actionCode.isNotEmpty) {
        return right('شما وارد شده اید');
      } else {
        return left('در ورود خطایی رخ داده است');
      }
    } on DioException catch (ex) {
      return left('${ex.message!}');
    }
  }
}
