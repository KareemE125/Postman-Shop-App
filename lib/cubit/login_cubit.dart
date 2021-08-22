import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/cubit/login_states.dart';
import 'package:post_man_api/helpers/cache_helper.dart';
import 'package:post_man_api/helpers/dio_helper.dart';
import 'package:post_man_api/models/user.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> login(String email, String password, BuildContext context) async
  {
    emit(LoginLoadingState());
    try
    {
      final Response response = await DioHelper.dio.post(
        'login',
        data: {
          "email": email,
          "password": password,
        },
      );
      if( response.data['status'] == false ){ throw(response.data['message']);  }
      User.fromJson(response.data);
      await CacheHelper.sharedPreferences.setString('token', response.data['data']['token']);
      emit(LoginSuccessState());
    }
    catch(error)
    {
      emit(LoginErrorState());
      toast(context,error.toString());
    }
  }

  Future<void> signUp(String name, String email, String phone, String password, BuildContext context) async
  {
    emit(SignUpLoadingState());
    try
    {
      final Response response = await DioHelper.dio.post(
        'register',
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }
      );
      if( response.data['status'] == false ){ throw(response.data['message']);  }
      User.fromJson(response.data);
      await CacheHelper.sharedPreferences.setString('token', response.data['data']['token']);
      emit(SignUpSuccessState());
    }
    catch(error)
    {
      emit(SignUpErrorState());
      toast(context,error.toString());
    }
  }

  Future<void> logout(BuildContext context) async
  {
    emit(LogoutLoadingState());
    try
    {
      final Response response = await DioHelper.dio.post('logout');
      if( response.data['status'] == false ){ throw(response.data['message']);  }
      await CacheHelper.sharedPreferences.remove('token');
      emit(LogoutSuccessState());
    }
    catch(error)
    {
      emit(LogoutErrorState());
      toast(context,error.toString());
    }
  }

}


