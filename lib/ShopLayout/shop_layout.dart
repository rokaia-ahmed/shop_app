import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';
import 'package:shop_app/shop_app/cubit/states.dart';
import 'package:shop_app/shop_app/search/search_screen.dart';


class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context , state){},
      builder: (context , state){
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('salla'),
            actions: [
              IconButton(
                  onPressed: ()
                  {
                   navigateTo(context,SearchScreen());
                  },
                  icon:Icon(Icons.search)),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              cubit.changeBottom(index);
            },
            currentIndex:cubit.currentIndex ,
            items: [
              BottomNavigationBarItem(
                  icon:Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.apps),
                label: 'categories',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.favorite),
                label: 'favorite',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.settings),
                label: 'settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
