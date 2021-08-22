class Categories
{
  bool? status;
  String? message;
  static List categoriesList = [];

  Categories.fromJson(Map<String,dynamic> data)
  {
    status = data['status'];
    message = data['message'];
    categoriesList = (data['data']['data'] as List).map((element) => Category.fromJson(element) ).toList();
  }

}

class Category
{
  int? id;
  String? name;
  String? imageUrl;

  Category.fromJson(Map<String,dynamic> data)
  {
    id = data['id'];
    name = data['name'];
    imageUrl = data['image'];
  }

}