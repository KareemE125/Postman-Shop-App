import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';
import 'package:post_man_api/models/Categories.dart';

class CategoriesScreen extends StatelessWidget {
  bool isInit = true;
  List productsList = [];
  int currentCategoryId = -1;

  Future<void> assignProductsList(BuildContext context, int id) async {
    await ShopCubit.get(context)
    .getProductsByCategoryId(context, id)
    .then((list)
    {
        if (list.isEmpty) {productsList = [false];}
        else {productsList = list;}
        currentCategoryId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context,states){
        if(states is ShopToggleFavoritesLoadingState || states is ShopToggleFavoritesErrorState )
        { assignProductsList(context, currentCategoryId); }
        if(states is ShopScreenIndexingState){ isInit = true; }
      },
      builder: (context,states){

        if(isInit) {
          if (Categories.categoriesList.isEmpty) {
            ShopCubit.get(context).getCategories(context)
            .then((value) {
                isInit = false;
                assignProductsList(context,Categories.categoriesList[0].id)
                .then((value) => currentCategoryId = Categories.categoriesList[0].id);
            });
          }
          else
          {
            isInit = false;
            assignProductsList(context,Categories.categoriesList[0].id).then((value) =>
            currentCategoryId = Categories.categoriesList[0].id);
          }
        }

        return Categories.categoriesList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                child: ListView.separated(
                  itemCount: Categories.categoriesList.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      child: categoriesListItem(index),
                      onTap: () async
                      {
                        productsList = [];
                        await assignProductsList( context, Categories.categoriesList[index].id);
                      },
                    );
                  },
                  separatorBuilder: (_, index) => Container(
                    width: 2,
                    color: Colors.grey[200],
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                ),
              ),
              productsList.isEmpty
                  ? Container(
                height: 300,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 5),
                    child: Text(
                      Categories.categoriesList
                          .firstWhere((element) =>
                      element.id == currentCategoryId)
                          .name,
                      style: kTextBodyRegular.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  productsList[0] == false
                      ? Container(
                    height: 300,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Image.network(
                      'https://res.cloudinary.com/bscfashion/image/upload/v1598209215/cv6cirpxqtdcvweosuis.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Container(
                    color: Colors.grey[200],
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        productsList.length,
                        (index) => productGridItem(context, index,filteredList:  productsList, isCategory: true),
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
            ],
          ),
        );
      },
    );
  }
}
