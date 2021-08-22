import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_man_api/components/widgets.dart';
import 'package:post_man_api/cubit/shop_cubit.dart';
import 'package:post_man_api/cubit/shop_states.dart';
import 'package:post_man_api/models/search.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context,state){},
          builder: (context,state){
            final ShopCubit cubit = ShopCubit.get(context);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      labelText: 'search',
                      focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Theme.of(context).accentColor)),
                    ),
                    style: TextStyle(color: Theme.of(context).accentColor),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    controller: searchController,
                    onChanged: (text){
                      if(searchController.text.isNotEmpty) {
                        cubit.search(context, searchController.text);
                      }
                    },
                  ),
                ),
                searchController.text.isEmpty
                ? Expanded(child: Center(child: Text('Search Text Is Empty\n!!!',style: TextStyle(fontSize: 30,color: Theme.of(context).accentColor.withOpacity(0.7)),textAlign: TextAlign.center,),))
                : Search.productsList.isEmpty
                    ? Center(child: CircularProgressIndicator(),)
                    :Search.productsList[0]==false
                    ? Expanded(child: Center(child: Text('No Items Found',style: TextStyle(fontSize: 30,color: Theme.of(context).accentColor.withOpacity(0.7)),textAlign: TextAlign.center,),))
                    : Expanded(child: Container(
                  color: Colors.grey[200],
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      Search.productsList.length,
                      (index) => productGridItem(context, index, filteredList: Search.productsList,isSearch: true),
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(1),
                    crossAxisSpacing: 1.2,
                    mainAxisSpacing: 1.2,
                    childAspectRatio: 1 / 1.56,
                  ),
                ),
                )
              ],
            );
          },
        )
      ),
    );
  }
}
