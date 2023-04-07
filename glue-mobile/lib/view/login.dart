import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/user_controller.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController name = TextEditingController(),
      token = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserController user = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Glue",
                    style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.15,
                        color: Color(0xff2C2B2B),
                        fontFamily: "Proxima Nova"),
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Name can't be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Name",
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0))),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      color: Color(0xff2C2B2B),
                      fontFamily: "Proxima Nova",
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Token can't be empty";
                      }
                      return null;
                    },
                    controller: token,
                    decoration: InputDecoration(
                        hintText: "Token",
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff2C2B2B), width: 2.0))),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      color: Color(0xff2C2B2B),
                      fontFamily: "Proxima Nova",
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            user.loginUser(name.text, token.text);
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 19),
                          backgroundColor: const Color(0xff2C2B2B),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        child: const Text("Login",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.15,
                              color: Colors.white,
                              fontFamily: "Proxima Nova",
                            ))),
                  )
                ]),
          )),
    );
  }
}
