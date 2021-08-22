import 'package:flutter/material.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/models/user.dart';
import 'package:post_man_api/screens/update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = '/profile_screen_screen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          color: Color(0xFFF7F8FA),
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 150),
                        profileInfoListTile('Id:', User.id.toString()),
                        Divider(color: Colors.grey),
                        profileInfoListTile('Name:', User.name!),
                        Divider(color: Colors.grey),
                        profileInfoListTile('Email:', User.email!),
                        Divider(color: Colors.grey),
                        profileInfoListTile('Phone:', User.phone!),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 50, bottom: 20),
                          child: ElevatedButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 40,
                              child: Text('EDIT',style: kTextButton1Regular.copyWith(fontWeight: FontWeight.w600,fontSize: 20),),
                            ),
                            onPressed: (){
                              Navigator.of(context).pushNamed(UpdateProfileScreen.routeName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 12,
                shape: CircleBorder(),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage(
                          'assets/images/profile2.png',
                        ),
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
