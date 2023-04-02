// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyrecord/config/app_asset.dart';
import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/data/model/source/source_user.dart';
import 'package:moneyrecord/presentation/page/home_page.dart';
import 'package:moneyrecord/presentation/page/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool emailValidation(String str) {
    if (str.length < 4) {
      return false;
    }

    if (!RegExp(r"@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(str)) {
      return false;
    }

    return true;
  }

  bool passwordValidation(String str) {
    if (str.length < 6) {
      return false;
    }

    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(str)) {
      return false;
    }
    return true;
  }

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  login() async {
    if (formkey.currentState!.validate()) {
      bool success =
          await SourceUser.login(controllerEmail.text, controllerPassword.text);
      if (success) {
        DInfo.dialogSuccess(context, 'Login Success');
        DInfo.closeDialog(context, actionAfterClose: () {
          Get.off(() => const HomePage());
        });
      } else {
        DInfo.dialogError(context, 'Login Failure');
        DInfo.closeDialog(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, contstrains) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: contstrains.maxHeight),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: const BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Your finances made simple',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 36,
                                      color: AppColor.secondary,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              AppAsset.loginPageMain,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                          ],
                        ),
                      ],
                    ),
                    DView.nothing(),
                    Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Hi! There',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.primary),
                                    ),
                                    Text(
                                      'I Am Waiting For You',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.primary),
                                    ),
                                  ],
                                ),
                              ),
                              DView.spaceHeight(),
                              emailForm(),
                              const SizedBox(
                                height: 24,
                              ),
                              passwordForm(),
                              DView.spaceHeight(),
                              loginButton()
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 16, right: 16, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum Punya Akun? ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const RegisterPage());
                            },
                            child: Text('Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColor.primary, fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

//NOTE : Login Button

  Widget loginButton() {
    return Material(
      color: AppColor.primary,
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        onTap: () => login(),
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Text(
            'LOGIN',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16, color: AppColor.secondary),
          ),
        ),
      ),
    );
  }

//NOTE : Password Input

  Widget passwordForm() {
    return TextFormField(
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (!passwordValidation(value)) {
          return 'Password must contain at least one letter\nand one number and be at least 8 characters long';
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controllerPassword,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: AppColor.secondary,
          ),
      obscureText: true,
      decoration: InputDecoration(
          fillColor: AppColor.primary,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          hintText: 'Your Password',
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColor.secondary, fontSize: 16),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
    );
  }

  //NOTE : Email Input

  Widget emailForm() {
    return TextFormField(
      controller: controllerEmail,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: AppColor.secondary,
          ),
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email Required';
        } else if (!emailValidation(value)) {
          return 'Invalid Email Format';
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          fillColor: AppColor.primary,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          hintText: 'Your Email',
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColor.secondary, fontSize: 16),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
    );
  }
}
