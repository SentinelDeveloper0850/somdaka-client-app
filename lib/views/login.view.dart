import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/helpers/regex.helper.dart';
import 'package:somdaka_client/models/auth/auth_request.model.dart';

import '../app.config.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool _isPerformingSignIn = false;

  final IAuthRequest _authRequest =
      IAuthRequest(email: "", password: "", product: AppConfig.PRODUCT_NAME);

  late final AuthController _authController;

  @override
  void initState() {

    if(Get.isRegistered<AuthController>()){
      _authController = Get.find<AuthController>();
    }else{
      _authController = Get.put(AuthController());
    }

    super.initState();
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _onSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isPerformingSignIn = true;
      });

      bool signInSuccessful = await _authController.signIn(_authRequest);

      if (signInSuccessful) {
        // Navigator.pushReplacementNamed(context, '/main');
        setState(() {
          _isPerformingSignIn = false;
        });
        // Get.offNamed('/home');
        Get.offNamed('/main');
      } else {
        setState(() {
          _isPerformingSignIn = false;
        });
      }
    }
  }

  Widget _signInForm() {
    return Form(
      key: globalKey,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  obscureText: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      focusColor: Colors.white,
                      border: UnderlineInputBorder(),
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                  validator: (input) =>
                      RegexHelper().isValidEmail(input!) == false
                          ? "Email is invalid"
                          : null,
                  onSaved: (input) => {
                    if (input != null) {_authRequest.email = input.toLowerCase()}
                  },
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                obscureText: hidePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    focusColor: Colors.white,
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )),
                validator: (input) =>
                    input!.length < 8 ? "Password is invalid" : null,
                onSaved: (input) => {
                  if (input != null) {_authRequest.password = input}
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 18),
              child: SizedBox(
                width: 300,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: _isPerformingSignIn ? null : _onSubmit,
                  onLongPress: (){ Get.offNamed('/home'); },
                  label: const Text(
                    "Member Login",
                    style: TextStyle(color: Colors.black87),
                  ),
                  icon: _isPerformingSignIn
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          CupertinoIcons.square_arrow_right,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLogin() {
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffFA9D00),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7ac5fe),
              Color(0xffFA9D00),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    SizedBox(
                      height: 30,
                    ),
                    Image(
                      image: AssetImage("assets/images/logo_sm.png"),
                      height: 100,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text('SOMDAKA FUNERAL SERVICES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                      child: Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 16.0,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                _signInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
