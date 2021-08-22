class Favorites
{
  static late bool status;
  static late String message;
  static late List productsList = [];

  Favorites.fromJson(Map<String,dynamic> data)
  {
    status = data['status'];
    if(data['message'] != null){  message = data['message']?? 'none'; }

    productsList = data['data']['data'].map((e) => FavoriteProduct.fromJson(e['product'])).toList();
  }

}


class FavoriteProduct
{
  late int id;
  late String name;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String imageUrl;
  late bool isFavorite = true;



  FavoriteProduct.fromJson(Map<String,dynamic> data)
  {
    id = data['id'];
    name = data['name'];
    price = data['price'];
    oldPrice = data['old_price'];
    discount = data['discount'];
    imageUrl = data['image'];

  }

}