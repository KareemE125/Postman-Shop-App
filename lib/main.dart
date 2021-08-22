import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/bloc_observer.dart';
import 'package:post_man_api/cubit/login_cubit.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/helpers/cache_helper.dart';
import 'package:post_man_api/helpers/dio_helper.dart';
import 'package:post_man_api/models/user.dart';
import 'package:post_man_api/screens/profile_screen.dart';
import 'package:post_man_api/screens/search_screen.dart';
import 'package:post_man_api/screens/shop_screen.dart';
import 'package:post_man_api/screens/auth_screens/login_screen.dart';
import 'package:post_man_api/screens/on_boarding_screen.dart';
import 'package:post_man_api/screens/auth_screens/signup_screen.dart';
import 'package:post_man_api/screens/update_profile_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();
  await CacheHelper.init();


    if( User.token == null )
    {
      String? token = CacheHelper.sharedPreferences.getString('token');
      if(token != null)
      {
        DioHelper.dio.options.headers.addAll({'Authorization' : token });
        await DioHelper.dio.get('profile')
            .then((response) => User.fromJson(response.data) );
      }
    }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => ShopCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: kThemeData,
        home: CacheHelper.sharedPreferences.getBool('isFirstTime') ?? true
            ? OnBoardingScreen()
            : CacheHelper.sharedPreferences.getString('token') != null
              ? ShopScreen()
              : LoginScreen(),
        routes: {
          LoginScreen.routeName: (_) => LoginScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
          ShopScreen.routeName: (_) => ShopScreen(),
          ProfileScreen.routeName: (_) => ProfileScreen(),
          UpdateProfileScreen.routeName: (_) => UpdateProfileScreen(),
          SearchScreen.routeName: (_) => SearchScreen(),
        },
      ),
    );
  }
}
