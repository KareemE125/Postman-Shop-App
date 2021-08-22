import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';
import 'package:post_man_api/models/favorites.dart';

class FavoritesScreen extends StatelessWidget {
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          final cubit = ShopCubit.get(context);
          if (isInit) {
            isInit = false;
            cubit.getFavorites(context)
            .then((value) {
              if (Favorites.productsList.isEmpty){ Favorites.productsList = [false]; }
            });
          }
          return Favorites.productsList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Favorites.productsList[0] == false
                  ? Container(
                      height: 300,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://res.cloudinary.com/bscfashion/image/upload/v1598209215/cv6cirpxqtdcvweosuis.jpg',
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey[200],
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: List.generate(
                                Favorites.productsList.length,
                                (index) => productGridItem(
                                    context, index, filteredList: Favorites.productsList),
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(1),
                              crossAxisSpacing: 1.2,
                              mainAxisSpacing: 1.2,
                              childAspectRatio: 1 / 1.56,
                            ),
                          ),
                        ],
                      ),
                    );
        });
  }
}
