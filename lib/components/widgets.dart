import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/models/Categories.dart';
import 'package:post_man_api/models/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void toast(BuildContext context, String message)
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ),
  );
}

dynamic bottomNavyBarItem(IconData icon, String title)
{
  return BottomNavyBarItem(
    icon: Icon(icon),
    title: Text(title),
    activeColor: Color(0xFF009688),
    textAlign: TextAlign.center,
  );
}

Widget bannersViewer(BuildContext context, PageController pageController)
{
  return Card(
    elevation: 5,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        /// that container is just to trigger the "SmoothPageIndicator"
        Container(
          height: 0,
          child: PageView.builder(
            itemBuilder: (c, i) => Container(),
            controller: pageController,
            itemCount: Home.bannersList.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: CarouselSlider(
              items: Home.bannersList.map((e) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColorDark,
                        Theme.of(context).accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),  
                  ),
                  height: 220,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: NetworkImage((e as HomeBanner).imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                  //height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (i, _) {
                    pageController.jumpToPage(i);
                  })),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SmoothPageIndicator(
            controller: pageController,
            count: Home.bannersList.length,
            effect: ScaleEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Colors.white38),
          ),
        ),
      ],
    ),
  );
}

Widget productGridItem( BuildContext context, int index, {List? filteredList, bool isCategory = false, bool isSearch = false})
{

  List productsList = [];
  if(filteredList == null){ productsList = Home.productsList; }
  else{ productsList = filteredList; }

  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: 200,
              padding: EdgeInsets.all(5),
              child: Image.network(
                productsList[index].imageUrl,
                width: double.infinity,
              ),
            ),
            if (productsList[index].discount!=null && productsList[index].discount > 0)
              Container(
                color: Colors.red,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                child: Text(
                  'DISCOUNT',
                  style: kTextSubRegular.copyWith(
                      color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 5),
            child: Column(
              children: [
                Text(
                  productsList[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kTextSubRegular,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      productsList[index]
                          .price
                          .toString(),
                      style: kTextSubRegular.copyWith(
                          color: Colors.teal[400], fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (isSearch == false && productsList[index].discount > 0)
                      Text(
                        productsList[index]
                            .oldPrice
                            .toString(),
                        style: kTextSubRegular.copyWith(
                            color: Colors.grey[500],
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    if(isSearch == false)
                    TextButton(
                      child: productsList[index].isFavorite
                          ? Icon(Icons.favorite,color: Colors.red,)
                          : Icon(Icons.favorite_outline, color: Colors.grey,),
                      onPressed:()
                      {
                        if(isCategory){ productsList[index].isFavorite = !productsList[index].isFavorite; }
                        ShopCubit.get(context).toggleFavorites(context, productsList[index].id);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget categoriesListItem(int index)
{
  return Container(
    width: 125,
    child: GridTile(
      child: Container(
        child: Image.network((Categories.categoriesList[index] as Category).imageUrl!,fit: BoxFit.cover,),
      ),
      footer: Container(
        height: 25,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 2),
        color: Colors.black45,
        child: Text(
          (Categories.categoriesList[index] as Category).name!,
          style: kTextSubRegular.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}

Widget profileInfoListTile(String label, String text)
{
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: kTextProfileRegular.copyWith(color: Colors.grey[600]),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            text,
            style: kTextProfileRegular,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
