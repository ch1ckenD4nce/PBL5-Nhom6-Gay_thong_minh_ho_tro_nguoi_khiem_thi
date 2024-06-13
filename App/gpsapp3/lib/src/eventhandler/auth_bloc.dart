import 'dart:async';

class AuthBloc {
  StreamController<String> _nameController = StreamController<String>();
  StreamController<String> _seriController = StreamController<String>();
  StreamController<String> _emailController = StreamController<String>();
  StreamController<String> _passwordController = StreamController<String>();

  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get seriStream => _seriController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  bool isValid(String name, String seri, String email, String password) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Nhập tên");
      return false;
    }
    _nameController.sink.add("");

    if (seri == null || seri.length == 0) {
      _seriController.sink.addError("Nhập Seri");
      return false;
    }
    _seriController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập Email");
      return false;
    }
    _emailController.sink.add("");

    if (password == null || password.length < 6) {
      _passwordController.sink.addError("Mật khẩu phải trên 6 ký tự");
      return false;
    }
    _passwordController.sink.add("");

    return true;
  }

  void dispose() {
    _nameController.close();
    _seriController.close();
    _emailController.close();
    _passwordController.close();
  }
}
