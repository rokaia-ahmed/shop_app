import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';
import 'package:shop_app/shop_app/cubit/states.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder:(context,state){
        return BuildCondition(
          condition: state is! ShopLoadingGetFavoritesState ,
          builder: (context) => ListView.separated(
            itemBuilder: (context ,index) =>buildFivList(
                ShopCubit.get(context).favoritesModel!.data!.data[index].product,context) ,
            separatorBuilder: (context ,index) =>myDivider() ,
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data.length,
          ),
          fallback:(context) => Center(child: CircularProgressIndicator()) ,
        );
      } ,
    ) ;
  }
  Widget buildFivList( model,context)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height:120.0 ,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image),
                width:120.0 ,
                height: 120.0,
              ),
              if(model.discount !=0 )
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 5.0,),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width:20.0 ,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight:FontWeight.bold ,
                    height: 1.3,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight:FontWeight.bold ,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width:10.0 ,
                    ),
                    if(model.discount !=0 )
                      Text(
                        model.oldPrice.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight:FontWeight.bold ,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    CircleAvatar(
                      radius: 15.0,
                      backgroundColor: ShopCubit.get(context).favorites[model.id]!? Colors.blue : Colors.grey,
                      child: IconButton(
                        onPressed: (){
                          ShopCubit.get(context).changeFavorites(model.id);
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white ,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
