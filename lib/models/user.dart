class User
{

  static String? token;
  static int? id;
  static String? name;
  static String? email;
  static String? phone;

  User.fromJson(Map<String,dynamic> userData)
  {
    token = userData['data']['token'];
    id = userData['data']['id'];
    name = userData['data']['name'];
    email = userData['data']['email'];
    phone = userData['data']['phone'];
  }

}