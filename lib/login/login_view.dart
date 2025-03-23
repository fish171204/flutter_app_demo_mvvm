import 'package:flutter/material.dart';
import 'package:flutter_app_demo_mvvm/home/home_view.dart';
import 'package:provider/provider.dart';
import 'login_bloc.dart';

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
      body: ChangeNotifierProvider(
        // Đây là nơi khởi tạo instance của LoginBloc.
        // BodyWidget là widget con sẽ nhận được LoginBloc từ Provider.
        create: (context) => LoginBloc(),
        child: const BodyWidget(),
      ),
    );
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

  @override
  void initState() {
    super.initState();

    // Khi người dùng nhập vào email, nó sẽ lắng nghe giá trị mới.
    // Sau đó, giá trị nhập vào sẽ được thêm vào stream (emailSink.add(emailController.text);).
    // Bất kỳ widget con nào trong BodyWidget có thể truy xuất LoginBloc bằng cách gọi: Provider.of<LoginBloc>(context);
    emailController.addListener(() {
      Provider.of<LoginBloc>(context, listen: false)
          .emailSink
          .add(emailController.text);
    });

    passController.addListener(() {
      Provider.of<LoginBloc>(context, listen: false)
          .passSink
          .add(passController.text);
    });
  }

  // dispose() sẽ được call tự động vì đã có provider

  @override
  Widget build(BuildContext context) {
    // lấy đối tượng LoginBloc từ Provider,
    var loginBloc = Provider.of<LoginBloc>(context);

    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<String?>(
            stream: loginBloc.emailStream,
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
            stream: loginBloc.passStream,
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
            stream: loginBloc.btnStream,
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
                          // Navigator.pushReplacement() -> Khi không muốn quay lại trang trước (vd: đăng nhập xong chuyển sang Home).
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
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
