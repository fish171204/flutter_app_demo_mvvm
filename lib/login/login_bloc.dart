// StreamTransformer giúp xử lý dữ liệu đầu vào trước khi nó đến được các StreamBuilder hoặc các phần khác của ứng dụng.
// Khi người dùng nhập email,pass... StreamTransformer sẽ kiểm tra tính hợp lệ của email,pass... đó.
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_demo_mvvm/helper/validation.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with ChangeNotifier {
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var emailValidation = StreamTransformer<String, String?>.fromHandlers(
      handleData: (email, sink) {
    final error = Validation.validateEmail(email);
    sink.add(error); // Phát null nếu email hợp lệ
  });

  var passValidation =
      StreamTransformer<String, String?>.fromHandlers(handleData: (pass, sink) {
    final error = Validation.validatePass(pass);
    sink.add(error); // Phát null nếu pass hợp lệ
  });

  // .transform(emailValidation): Áp dụng StreamTransformer để kiểm tra và xử lý dữ liệu trước khi gửi đi.
  Stream<String?> get emailStream =>
      _emailSubject.stream.transform(emailValidation).skip(1);
  Sink<String> get emailSink => _emailSubject.sink;

  // .transform(passValidation): Áp dụng StreamTransformer để kiểm tra và xử lý dữ liệu trước khi gửi đi.
  Stream<String?> get passStream =>
      _passSubject.stream.transform(passValidation).skip(1);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  LoginBloc() {
    // Kết hợp 2 stream
    Rx.combineLatest2(_emailSubject, _passSubject, (String email, String pass) {
      return Validation.validateEmail(email) == null &&
          Validation.validatePass(pass) == null;
    }).listen((isValid) {
      btnSink.add(isValid);
    });
  }

  @override
  dispose() {
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();

    super.dispose();
  }
}
