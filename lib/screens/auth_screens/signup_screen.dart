import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/default_text_form_field.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/login_cubit.dart';
import 'package:post_man_api/cubit/login_states.dart';
import 'package:post_man_api/screens/shop_screen.dart';
import 'package:post_man_api/screens/auth_screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = '/signup_screen';
  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  late String helperTextName = "", helperTextPass = "";
  late String _userName, _userEmail, _userPass, _userPhone;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
    listener: (context, states)
    {
    if( states is SignUpSuccessState ){ Navigator.of(context).pushReplacementNamed(ShopScreen.routeName);}

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
            child: Container(
                padding: EdgeInsets.all(18),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('SignUp',style: kTextHeadRegular.copyWith(fontSize: 35, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10,),
                                  Text('SignUp now and explore our exclusive products.',style: kTextSubRegular.copyWith(color: Colors.grey[800]),),
                                ],
                              )
                          ),
                          SizedBox(height: 30,),
                          DefaultTextFormField(
                            maxLength: 35,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.person,
                            labelText: "Your Name",
                            validatorFunction: (value)
                            {
                              if (value!.isEmpty == true){ return "Please Enter Your Name"; }
                              else if (value!.length < 3){ return "Name must contain at least 3 characters"; }
                            },
                            onSavedFunction: (value) { _userName = value; },
                            onChangedFunction: (value) {setState(() {
                              helperTextName = "name can contain any characters like:(a,1,%,#,+).";
                            });},
                            onFieldSubmittedFunction: (value) {setState(() {
                              helperTextName = "";
                            });},
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          DefaultTextFormField(
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.email,
                            labelText: "Email Address",
                            validatorFunction: (value)
                            {
                              if ( value!.isEmpty == true || value.length < 5 || value!.contains(new RegExp(r'^(?=.*?[@])(?=.*?[.]).{8,}$')) == false )
                              { return "Please enter a valid e-mail"; }
                            },
                            onSavedFunction: (value) { _userEmail = value; },
                          ),
                          Padding(padding: EdgeInsets.all(15)),
                          DefaultTextFormField(
                            maxLength: 11,
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.phone,
                            labelText: "Your Phone Number",
                            validatorFunction: (value)
                            {
                              if (value!.isEmpty == true){ return "Please Enter Your Phone Number"; }
                              else if (value!.length < 11){ return "Phone Number must contain 11 characters"; }
                            },
                            onSavedFunction: (value) { _userPhone = value; },
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          DefaultTextFormField(
                            maxLength: 20,
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            isObscure: true,
                            prefixIcon: Icons.lock,
                            labelText: "Password",
                            validatorFunction: (value) {
                              if ( value!.isEmpty == true ) { return "Please Enter Your Password"; }
                              else if ( value!.length < 8 ) { return "Password should contain 8 characters at least."; }
                              else if ( value.contains(new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')) == false )
                              { return "Password should contain 1 UPPERCASE,\n1 lowercase, 1 num6er and 1 special at least."; }
                            },
                            onSavedFunction: (value){ _userPass = value; },
                            onFieldSubmittedFunction: (value) async {
                              setState((){ helperTextPass = ""; });
                              if (formStateKey.currentState!.validate() == true) {
                                formStateKey.currentState!.save();
                                await cubit.signUp(_userName,_userEmail,_userPhone,_userPass,context);
                              }
                            },
                            onChangedFunction: (value){ setState((){
                              helperTextPass = "Password should contain 8 characters, 1 UC,\n1 LC, 1 number and 1 special character at least.";
                            }); },
                          ),
                          Padding(padding: EdgeInsets.all(12)),
                          states is SignUpLoadingState
                          ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          )
                          : ElevatedButton(
                            child: Container(width:double.infinity,alignment: Alignment.center,child: Text("SignUp",style: TextStyle(fontSize: 20, color: Colors.white,),)),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 30),),
                              elevation: MaterialStateProperty.all(4),
                            ),
                            onPressed: () async {
                              if (formStateKey.currentState!.validate() == true) {
                                formStateKey.currentState!.save();
                                await cubit.signUp(_userName,_userEmail,_userPhone,_userPass,context);
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?',style: kTextSubRegular,),
                              TextButton(
                                child: Text("Login "),
                                onPressed:(){ Navigator.of(context).pushReplacementNamed( LoginScreen.routeName ); },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    }
    );
  }
}
