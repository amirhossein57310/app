abstract class AuthEvent {}

class AuthLoginRequest extends AuthEvent {
  String mobile;
  String email;
  AuthLoginRequest(this.mobile, this.email);
}

class AuthVerifingRequest extends AuthEvent {
  String mobile;
  String email;
  String firstname;
  String lastname;
  String code;
  AuthVerifingRequest(
    this.mobile,
    this.email,
    this.firstname,
    this.lastname,
    this.code,
  );
}
