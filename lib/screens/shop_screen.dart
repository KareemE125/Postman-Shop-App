import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/my_app_drawer.dart';
import 'package:post_man_api/components/widgets.dart';

import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';


class ShopScreen extends StatelessWidget {
  static final routeName = '/shop_screen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, states) {},
      builder: (context, states) {
        final cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.shopScreens[cubit.currentScreenIndex]['title']),
            centerTitle: true,
          ),
          drawer: MyAppDrawer(),
          body: cubit.shopScreens[cubit.currentScreenIndex]['screen'],
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: cubit.currentScreenIndex,
            showElevation: true,
            itemCornerRadius: 10,
            curve: Curves.easeIn,
            onItemSelected: (index){ cubit.changeScreenIndex(index); },
            items: [
              bottomNavyBarItem(Icons.home,'Home'),
              bottomNavyBarItem(Icons.apps,'Categories'),
              bottomNavyBarItem(Icons.favorite,'Favorites'),
              bottomNavyBarItem(Icons.person,'Profile'),
            ],
          ),
        );
      },
    );
  }
}
