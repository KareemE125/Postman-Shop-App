class Home
{
  static late bool status;
  static late String message;
  static late List bannersList = [];
  static late List productsList = [];

  Home.fromJson(Map<String,dynamic> data)
  {
    status = data['status'];
    if(data['message'] != null){  message = data['message']?? 'none'; }

    bannersList = data['data']['banners'].map((e) => HomeBanner.fromJson(e)).toList();
    productsList = data['data']['products'].map((e) => HomeProduct.fromJson(e)).toList();
  }

}

class HomeBanner
{
  late int id;
  late String imageUrl;
  late String categoryName;

  HomeBanner.fromJson(Map<String,dynamic> data)
  {
    id = data['id'];
    imageUrl = data['image'];
    if( data['category'] != null ){ categoryName = data['category']['name']; }
  }

}

class HomeProduct
{
  late int id;
  late String name;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount = 0;
  late String imageUrl;
  late bool isFavorite;
  late bool isInCart;

  HomeProduct.fromJson(Map<String,dynamic> data)
  {
    id = data['id'];
    name = data['name'];
    price = data['price'];
    oldPrice = data['old_price'];
    discount = data['discount'];
    imageUrl = data['image'];
    isFavorite = data['in_favorites'];
    isInCart = data['in_cart'];
  }

}