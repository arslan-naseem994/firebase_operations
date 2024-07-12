import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/auth/forgot_password.dart';
import 'package:firebases/view/auth/phone_signin.dart';
import 'package:firebases/view/auth/signup_screen.dart';
import 'package:firebases/view/home_crus_operation/home_screen.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  bool _visibility = true;
  bool _loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void login() {
    setState(() {
      _loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils.toastMessage(context, 'Successfully Login');
      setState(() {
        _loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const HomeScreen())));
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
      });
      Utils.toastMessage(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('LoginScreen'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email', prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _passwordFocus,
                      obscureText: _visibility,
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                              onTap: () {
                                _visibility = !_visibility;
                                setState(() {});
                              },
                              child: Icon(_visibility
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            RoundButton(
              loading: _loading,
              ontap: () {
                if (_formkey.currentState!.validate()) {
                  login();
                }
              },
              title: 'Login',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const ForgotPasswordScreen())));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const PhoneSigninScreen())));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                fixedSize: const Size(200, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ), // Set text color
              ),
              child: const Text('Phone Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: const Text("Signup"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
