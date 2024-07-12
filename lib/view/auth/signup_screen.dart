import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/auth/login_screen.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  bool _visibility = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Signup'),
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
                setState(() {
                  _loading = true;
                });

                login();
              }
            },
            title: 'Signup',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Login"))
            ],
          ),
        ],
      ),
    );
  }

  void login() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        _loading = false;
        Utils.toastMessage(context, 'Account Registed Successfully');
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const LoginScreen())));
      });
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
        Utils.toastMessage(context, error.toString());
      });
    });
  }
}
