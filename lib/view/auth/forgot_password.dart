import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:firebases/view/auth/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password_Reset_Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: TextFormField(
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
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              ontap: () {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });

                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    Utils.toastMessage(context,
                        'We have sent you an email to recover your password');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils.toastMessage(context, error.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                    setState(() {
                      loading = false;
                    });
                  });
                }
              },
              loading: loading,
              title: 'Forgot',
            )
          ],
        ),
      ),
    );
  }
}
