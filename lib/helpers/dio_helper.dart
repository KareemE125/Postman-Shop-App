import 'package:dio/dio.dart';

class DioHelper{

  static late Dio _dio;

  static void init()
  {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      headers: {'lang':'en'},
      receiveDataWhenStatusError: true
    ));
  }

  static Dio get dio => _dio;

}