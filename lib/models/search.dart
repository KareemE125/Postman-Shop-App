import 'package:post_man_api/models/home.dart';

class Search
{
  static late bool status;
  static late String message;
  static late List productsList = [];

  Search.fromJson(Map<String,dynamic> data)
  {
    status = data['status'];
    if(data['message'] != null){  message = data['message']?? 'none'; }

    productsList = data['data']['data'].map((e) => HomeProduct.fromJson(e)).toList();
  }

}