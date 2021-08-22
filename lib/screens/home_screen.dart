import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';
import 'package:post_man_api/models/Categories.dart';
import 'package:post_man_api/models/home.dart';

class HomeScreen extends StatelessWidget {
  bool isInit = true;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          final cubit = ShopCubit.get(context);
          if (isInit) {
            isInit = false;
            cubit.getHomeData(context);
            cubit.getCategories(context);
          }
          return Home.productsList.isEmpty || Categories.categoriesList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bannersViewer(context, _pageController),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Text(
                          'Categories',
                          style: kTextBodyRegular.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      ),
                      InkWell(
                        onTap: (){ cubit.changeScreenIndex(1); },
                        splashColor: Colors.tealAccent,
                        child: Container(
                          height: 110,
                          child: ListView.separated(
                            itemCount: Categories.categoriesList.length,
                            itemBuilder: (_, index) {
                              return categoriesListItem(index);
                            },
                            separatorBuilder: (_, index) => Container(
                              width: 2,
                              color: Colors.grey[200],
                            ),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Text(
                          'Recent Products',
                          style: kTextBodyRegular.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      ),
                      Container(
                        color: Colors.grey[200],
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                            Home.productsList.length,
                            (index) => productGridItem(context, index),
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
