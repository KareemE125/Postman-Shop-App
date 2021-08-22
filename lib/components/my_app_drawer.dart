import 'package:flutter/material.dart';
import 'package:post_man_api/components/loading_spinner.dart';
import 'package:post_man_api/cubit/login_cubit.dart';
import 'package:post_man_api/screens/search_screen.dart';
import 'package:post_man_api/screens/update_profile_screen.dart';
import 'package:restart_app/restart_app.dart';


class MyAppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar( title: Text('Where To Go!'),),
          Divider(height: 5,thickness: 3,color: Colors.grey[300],),
          ListTile(leading: Icon(Icons.shop_two),title: Text('SEARCH'),onTap: () => Navigator.of(context).pushNamed(SearchScreen.routeName)),
          Divider(height: 5,thickness: 3,color: Colors.grey[300],),
          ListTile(leading: Icon(Icons.edit_outlined),title: Text('Update Profile'),onTap: () => Navigator.of(context).pushNamed(UpdateProfileScreen.routeName),),
          Divider(height: 5,thickness: 3,color:Colors.grey[300]),
          Spacer(),
          Divider(height: 5,thickness: 3,color:Colors.grey[300]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LOGOUT'),
            onTap: ()
            {
              LoadingSpinner(context);
              LoginCubit.get(context).logout(context)
              .then((value) => Navigator.of(context).pop())
              .then((value) => Restart.restartApp());

            },
          ),
          Divider(height: 5,thickness: 3,color:Colors.grey[300]),
          SizedBox(height: 5,)
        ],
      ),
    );
  }
}
