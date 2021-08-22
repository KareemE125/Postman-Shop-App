import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/cubit/shop_states.dart';
import 'package:post_man_api/helpers/cache_helper.dart';
import 'package:post_man_api/helpers/dio_helper.dart';
import 'package:post_man_api/models/Categories.dart';
import 'package:post_man_api/models/favorites.dart';
import 'package:post_man_api/models/home.dart';
import 'package:post_man_api/models/search.dart';
import 'package:post_man_api/models/user.dart';
import 'package:post_man_api/screens/favorites_screen.dart';
import 'package:post_man_api/screens/home_screen.dart';
import 'package:post_man_api/screens/categoriets_screen.dart';
import 'package:post_man_api/screens/profile_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getHomeData(BuildContext context) async {
    emit(ShopHomeLoadingState());
    try {
      DioHelper.dio.options.headers.addAll(
          {'Authorization': CacheHelper.sharedPreferences.getString('token')});
      final Response response = await DioHelper.dio.get('home');

      if (response.data['status'] == false) {
        throw (response.data['message']);
      }
      Home.fromJson(response.data);
      emit(ShopHomeSuccessState());
    } catch (error) {
      emit(ShopHomeErrorState());
      toast(context, error.toString());
    }
  }

  Future<void> updateProfile(String name, String email, String phone, BuildContext context) async
  {
    emit(ShopProfileUpdateLoadingState());
    try {
      DioHelper.dio.options.headers.addAll(
          {'Authorization': CacheHelper.sharedPreferences.getString('token')});
      final Response response = await DioHelper.dio.put('update-profile',
          data: {"name": name, "email": email, "phone": phone});
      if (response.data['status'] == false) {
        throw (response.data['message']);
      }
      User.fromJson(response.data);
      emit(ShopProfileUpdateSuccessState());
    } catch (error) {
      emit(ShopProfileUpdateErrorState());
      toast(context, error.toString());
    }
  }

  Future<void> getCategories(BuildContext context) async
  {
    emit(ShopCategoriesLoadingState());
    try {
      final Response response = await DioHelper.dio.get('categories');
      if (response.data['status'] == false) {
        throw (response.data['message']);
      }
      Categories.fromJson(response.data);
      emit(ShopCategoriesSuccessState());
    } catch (error) {
      emit(ShopCategoriesErrorState());
      toast(context, error.toString());
    }
  }

  Future<dynamic> getProductsByCategoryId(BuildContext context, int id) async
  {
    emit(ShopProductsByCategoryIdLoadingState());
    try {
      final Response response = await DioHelper.dio.get('categories/$id');
      if (response.data['status'] == false) {
        throw (response.data['message']);
      }
      List filteredProductsList = (response.data['data']['data'] as List)
          .map((e) => HomeProduct.fromJson(e))
          .toList();
      emit(ShopProductsByCategoryIdSuccessState());
      return filteredProductsList;
    } catch (error) {
      emit(ShopProductsByCategoryIdErrorState());
      toast(context, error.toString());
    }
  }

  Future<void> getFavorites(BuildContext context) async
  {
    emit(ShopFavoritesLoadingState());
    try {
      DioHelper.dio.options.headers.addAll(
          {'Authorization': CacheHelper.sharedPreferences.getString('token')});
      final Response response = await DioHelper.dio.get('favorites');

      if (response.data['status'] == false) {
        throw (response.data['message']);
      }
      Favorites.fromJson(response.data);
      emit(ShopFavoritesSuccessState());
    } catch (error) {
      emit(ShopFavoritesErrorState());
      toast(context, error.toString());
    }
  }

  Future<void> toggleFavorites(BuildContext context, int id) async
  {
    if(Favorites.productsList.isNotEmpty && Favorites.productsList[0] == false){Favorites.productsList.clear();}
    int indexOfProduct = Home.productsList.indexWhere((element) => element.id == id);
    Home.productsList[indexOfProduct].isFavorite = !Home.productsList[indexOfProduct].isFavorite;
    if(Home.productsList[indexOfProduct].isFavorite) {Favorites.productsList.add(Home.productsList[indexOfProduct]);}
    else {Favorites.productsList.removeWhere((element) => element.id == id);}

    emit(ShopToggleFavoritesLoadingState());

    try {
      DioHelper.dio.options.headers.addAll({'Authorization': CacheHelper.sharedPreferences.getString('token')});
      final Response response = await DioHelper.dio.post('favorites', data: {"product_id": id},);

      if (response.data['status'] == false){ throw (response.data['message']); }
      if (Favorites.productsList.isEmpty){ Favorites.productsList = [false]; }

      emit(ShopToggleFavoritesSuccessState());
    }
    catch (error)
    {
      Home.productsList[indexOfProduct].isFavorite = !Home.productsList[indexOfProduct].isFavorite;
      if(Home.productsList[indexOfProduct].isFavorite) {Favorites.productsList.add(Home.productsList[indexOfProduct]);}
      else {Favorites.productsList.removeWhere((element) => element.id == id);}
      if (Favorites.productsList.isEmpty){ Favorites.productsList = [false]; }

      emit(ShopToggleFavoritesErrorState());

      if(Home.productsList[indexOfProduct].isFavorite){ toast(context, 'failed to remove from Favorites'); }
      else{ toast(context, 'failed to add to Favorites'); }

    }
  }

  Future<void> search(BuildContext context, String text) async
  {
    emit(ShopSearchLoadingState());
    try
    {
      DioHelper.dio.options.headers.addAll({'Authorization': CacheHelper.sharedPreferences.getString('token')});
      final Response response = await DioHelper.dio.post('products/search', data: { "text": text },);
      if (response.data['status'] == false){ throw (response.data['message']); }


      Search.fromJson(response.data);
      if(response.data['data']['data'].isEmpty){ Search.productsList = [false]; }

      emit(ShopSearchSuccessState());
    }
    catch (error)
    {
      emit(ShopSearchErrorState());
      toast(context, 'failed to search');
    }
  }

  int currentScreenIndex = 0;
  List<Map<String, dynamic>> shopScreens = [
    {'title': 'Home', 'screen': HomeScreen()},
    {'title': 'Categories', 'screen': CategoriesScreen()},
    {'title': 'Favorites', 'screen': FavoritesScreen()},
    {'title': 'Profile', 'screen': ProfileScreen()},
  ];

  void changeScreenIndex(int index) {
    currentScreenIndex = index;
    emit(ShopScreenIndexingState());
  }
}
