import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/default_text_form_field.dart';
import 'package:post_man_api/constants.dart';

import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';

class UpdateProfileScreen extends StatefulWidget {
  static final routeName = '/update_profile_screen_screen';
  @override
  State<StatefulWidget> createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  late String helperTextName = "", helperTextPass = "";
  late String? _userName, _userEmail, _userPhone;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states)
        {
          if( states is ShopProfileUpdateSuccessState ){ Navigator.of(context).pop(); }
        },
        builder: (context, states) {
          final cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Update Profile'),
              centerTitle: true,
            ),
            body: Container(
              color: Color(0xFFF7F8FA),
              alignment: Alignment.center,
              padding: EdgeInsets.all(18),
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
                              Text('New Information',style: kTextHeadRegular.copyWith(fontSize: 35, fontWeight: FontWeight.w500),),
                              SizedBox(height: 50,),
                              DefaultTextFormField(
                                maxLength: 35,
                                textInputType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.person,
                                labelText: "New Name",
                                validatorFunction: (value)
                                {
                                  if (value!.isEmpty == true){ return "Please Enter Your Name"; }
                                  else if (value!.length < 3){ return "Name must contain at least 3 characters"; }
                                },
                                onSavedFunction: (value) { _userName = value; },
                                onChangedFunction: (value) {setState(() {helperTextName = "name can contain any characters like:(a,1,%,#,+).";});},
                                onFieldSubmittedFunction: (value) {setState(() {helperTextName = "";});},
                              ),
                              Padding(padding: EdgeInsets.all(8)),
                              DefaultTextFormField(
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.email,
                                labelText: "New Email Address",
                                validatorFunction: (value)
                                {
                                  if ( value!.isEmpty == true || value.length < 5 || value!.contains(new RegExp(r'^(?=.*?[@])(?=.*?[.]).{8,}$')) == false )
                                  { return "Please enter a valid e-mail"; }
                                },
                                onSavedFunction: (value) { _userEmail = value; },
                              ),
                              Padding(padding: EdgeInsets.all(18)),
                              DefaultTextFormField(
                                maxLength: 11,
                                textInputType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icons.phone,
                                labelText: "New Phone Number",
                                validatorFunction: (value)
                                {
                                  if (value!.isEmpty == true){ return "Please Enter Your Phone Number"; }
                                  else if (value!.length < 11){ return "Phone Number must contain 11 characters"; }
                                },
                                onSavedFunction: (value) { _userPhone = value; },
                                onFieldSubmittedFunction: (value) async {
                                  if (formStateKey.currentState!.validate() == true) {
                                    formStateKey.currentState!.save();
                                    await cubit.updateProfile(_userName!,_userEmail!,_userPhone!,context);
                                  }
                                },
                              ),
                              SizedBox(height: 50),
                              states is ShopProfileUpdateLoadingState
                              ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: CircularProgressIndicator(),
                              )
                              : ElevatedButton(
                                child: Container(width:double.infinity,alignment: Alignment.center,child: Text("Update",style: TextStyle(fontSize: 20, color: Colors.white,),)),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 30),),
                                  elevation: MaterialStateProperty.all(4),
                                ),
                                onPressed: () async {
                                  if (formStateKey.currentState!.validate() == true) {
                                    formStateKey.currentState!.save();
                                    await cubit.updateProfile(_userName!,_userEmail!,_userPhone!,context);
                                  }
                                },
                              ),

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
