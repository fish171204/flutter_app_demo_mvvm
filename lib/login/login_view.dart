import 'dart:math';

import 'package:flutter/material.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: const BodyWidget());
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final loginViewModel = LoginViewmodel();

  @override
  void initState() {
    super.initState();

    // Khi người dùng nhập vào email, nó sẽ lắng nghe giá trị mới.
    // Sau đó, giá trị nhập vào sẽ được thêm vào stream (emailSink.add(emailController.text);).
    emailController.addListener(() {
      loginViewModel.emailSink.add(emailController.text);
    });

    // Tuong tu
    passController.addListener(() {
      loginViewModel.passSink.add(passController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();

    loginViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<String?>(
            stream: loginViewModel.emailStream,
            builder: (context, snapshot) => TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                icon: const Icon(Icons.email),
                hintText: "example@gmail.com",
                labelText: "Email *",
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                errorText: snapshot.hasData ? snapshot.data : null,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<String?>(
            stream: loginViewModel.passStream,
            builder: (context, snapshot) => TextFormField(
              controller: passController,
              decoration: InputDecoration(
                icon: const Icon(Icons.lock),
                labelText: "Password *",
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: snapshot.hasData ? snapshot.data : null,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          StreamBuilder(
            stream: loginViewModel.btnStream,
            builder: (context, snapshot) => SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  // Đây là cách bật/tắt nút đăng nhập dựa trên tính hợp lệ của email và password trong StreamBuilder.
                  onPressed: snapshot.data == true
                      ? () {
                          // call login api
                          print("call login api");
                        }
                      : null,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
