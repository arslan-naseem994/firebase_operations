import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/auth/phone_verify_screen.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:flutter/material.dart';

class PhoneSigninScreen extends StatefulWidget {
  const PhoneSigninScreen({super.key});

  @override
  State<PhoneSigninScreen> createState() => _PhoneSigninScreenState();
}

class _PhoneSigninScreenState extends State<PhoneSigninScreen> {
  String? code = 'not selected';

  TextEditingController phoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhoneLoginScreen'),
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
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              fixedSize: const Size(120, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ), // Set text color
                            ),
                            onPressed: () {
                              showCountryPicker(
                                context: context,
                                onSelect: (value) {
                                  debugPrint(value.phoneCode);
                                  setState(() {
                                    code = value.phoneCode.toString();
                                  });
                                },
                              );
                            },
                            child: const Text(
                              textAlign: TextAlign.center,
                              'Select Code',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(code.toString()),
                    ],
                  ),
                  TextFormField(
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                        hintText: '0000 0000000',
                        label: Text('Enter Phone Number'),
                        prefixIcon: Icon(Icons.phone_android_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Phone Number';
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
              if (code == 'not selected') {
                Utils.toastMessage(context, 'Country code is not selected');
              } else {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });

                  login();
                }
              }
            },
            loading: _loading,
            title: 'Login',
          )
        ],
      ),
    );
  }

  void login() {
    _auth.verifyPhoneNumber(
        phoneNumber: "+$code${phoneController.text.toString()}",
        verificationCompleted: (_) {
          setState(() {
            _loading = false;
          });
        },
        verificationFailed: (error) {
          setState(() {
            _loading = false;
          });
          Utils.toastMessage(context, error.toString());
        },
        codeSent: (String verification, int? token) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PhoneVerifyScreen(
                        verificationid: verification,
                      ))));
          setState(() {
            _loading = false;
          });
        },
        codeAutoRetrievalTimeout: (error) {
          setState(() {
            _loading = false;
          });
          Utils.toastMessage(context, error.toString());
        });
  }
}
