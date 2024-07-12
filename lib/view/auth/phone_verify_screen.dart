import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/home_crus_operation/home_screen.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:flutter/material.dart';

class PhoneVerifyScreen extends StatefulWidget {
  final String verificationid;
  const PhoneVerifyScreen({super.key, required this.verificationid});

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  TextEditingController phoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhoneVerificationScreen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    maxLength: 6,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                        hintText: '######',
                        label: Text('Enter Verification Code'),
                        prefixIcon: Icon(Icons.phone_android_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Code';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          RoundButton(
            ontap: () {
              if (_formkey.currentState!.validate()) {
                setState(() {
                  _loading = true;
                });
                login();
              }
            },
            loading: _loading,
            title: 'Verify',
          )
        ],
      ),
    );
  }

  void login() async {
    final credentials = PhoneAuthProvider.credential(
        verificationId: widget.verificationid.toString(),
        smsCode: phoneController.text.toString());

    try {
      await _auth.signInWithCredential(credentials).then((value) {
        setState(() {
          _loading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }).onError((error, stackTrace) {
        setState(() {
          _loading = false;
        });
        Utils.toastMessage(context, error.toString());
      });
    } catch (e) {
      Utils.toastMessage(context, e.toString());
    }
  }
}
