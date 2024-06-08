import 'package:bloc/bloc.dart';
import 'package:hess_app/bloc/authetication/auth_event.dart';
import 'package:hess_app/bloc/authetication/auth_state.dart';

import '../../data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthenticationRepositories _repository;
  AuthBloc(this._repository) : super(AuthInitState()) {
    on<AuthLoginRequest>((event, emit) async {
      //  emit(AuthLoadingState());
      var response = await _repository.login(event.mobile, event.email);
      emit(AuthResponseState(response));
    });
    on<AuthVerifingRequest>((event, emit) async {
      //  emit(AuthLoadingState());
      var response = await _repository.verifing(event.mobile, event.email,
          event.firstname, event.lastname, event.code);
      emit(AuthResponseState(response));
    });
    on<AuthSecondVerifingRequest>((event, emit) async {
      //  emit(AuthLoadingState());
      var response = await _repository.secondVerifing(event.mobile, event.email,
          event.firstname, event.lastname, event.code);
      emit(AuthResponseState(response));
    });
  }
}
