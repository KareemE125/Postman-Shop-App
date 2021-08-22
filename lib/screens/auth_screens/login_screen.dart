import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/default_text_form_field.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/login_cubit.dart';
import 'package:post_man_api/cubit/login_states.dart';
import 'package:post_man_api/helpers/cache_helper.dart';
import 'package:post_man_api/screens/shop_screen.dart';
import 'package:post_man_api/screens/auth_screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = '/login_screen';

  LoginScreen(){ CacheHelper.sharedPreferences.setBool('isFirstTime', false); }
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  late String helperTextPass = "";
  late String _userEmail, _userPass;

  Future<void> login() async {
    if (formStateKey.currentState!.validate() == true) {
      formStateKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, states)
      {
        if( states is LoginSuccessState ){ Navigator.of(context).pushReplacementNamed(ShopScreen.routeName); }

      },
      builder: (context, states) {
        final cubit = LoginCubit.get(context);
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                 colors: [
                   Theme.of(context).primaryColorDark,
                   Theme.of(context).primaryColor.withOpacity(0.9),
                   Theme.of(context).primaryColor.withOpacity(0.7),
                   Theme.of(context).accentColor.withOpacity(0.6),
                   Theme.of(context).accentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: formStateKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Login',
                                  style: kTextHeadRegular.copyWith(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Login now and explore our exclusive products.',
                                  style: kTextSubRegular.copyWith(
                                      color: Colors.grey[800]),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultTextFormField(
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.email,
                          labelText: "Email Address",
                          validatorFunction: (value) {
                            if (value!.isEmpty == true ||
                                value.length < 5 ||
                                value!.contains(new RegExp(
                                        r'^(?=.*?[@])(?=.*?[.]).{8,}$')) ==
                                    false) {
                              return "Please enter a valid e-mail";
                            }
                          },
                          onSavedFunction: (value) {
                            _userEmail = value;
                          },
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        DefaultTextFormField(
                          maxLength: 20,
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          isObscure: true,
                          prefixIcon: Icons.lock,
                          labelText: "Password",
                          validatorFunction: (value) {
                            if (value!.isEmpty == true) {
                              return "Please Enter Your Password";
                            } else if (value!.length < 8) {
                              return "Password should contain 8 characters at least.";
                            } else if (value.contains(new RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')) ==
                                false) {
                              return "Password should contain 1 UPPERCASE,\n1 lowercase, 1 num6er and 1 special at least.";
                            }
                          },
                          onSavedFunction: (value) {
                            _userPass = value;
                          },
                          onFieldSubmittedFunction: (value) async {
                            setState(() {helperTextPass = "";});
                            if (formStateKey.currentState!.validate() == true) {
                              formStateKey.currentState!.save();
                              await cubit.login(_userEmail, _userPass, context);
                            }
                          },
                          onChangedFunction: (value) {
                            setState(() {
                              helperTextPass =
                                  "Password should contain 8 characters, 1 UC,\n1 LC, 1 number and 1 special character at least.";
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        states is LoginLoadingState
                        ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        )
                        : ElevatedButton(
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text("Login", style: TextStyle(fontSize: 20, color: Colors.white,),),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                            ),
                            elevation: MaterialStateProperty.all(4),
                          ),
                          onPressed: () async {
                            if (formStateKey.currentState!.validate() == true) {
                              formStateKey.currentState!.save();
                              await cubit.login(_userEmail, _userPass, context);
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: kTextSubRegular,
                            ),
                            TextButton(
                              child: Text(
                                "SignUp ",
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    SignUpScreen.routeName);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
