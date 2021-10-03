import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_models.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';
import 'package:shop_app/shop_app/cubit/states.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){
          if(state is ShopSuccessChangeFavoritesState){
              if(!state.model.status!){
                  showToast(text: state.model.message!, state:ToastStates.warning);
              }
          }
        },
        builder: (context,state){
          return BuildCondition(
            condition:ShopCubit.get(context).homeModel!= null && ShopCubit.get(context).categoriesModel!= null,
            builder:(context)=> productsBuilder(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!,context) ,
             fallback: (context)=> Center(child:CircularProgressIndicator()),
          );
    },
    );
  }

  Widget productsBuilder(HomeModel model,CategoriesModel categoriesModel,context){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          CarouselSlider(
            items: model.data.banners.map((e) =>  Image(
              image:NetworkImage('${e.image}'),
              width: double.infinity,
              fit:BoxFit.cover ,
            ), ).toList(),
            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              viewportFraction: 1.0,
              autoPlay: true,
              reverse: false,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 2),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ) ,
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start ,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index)=> buildCategoryItem(categoriesModel.data!.data[index]),
                      separatorBuilder: (context,index) => SizedBox(width: 10,),
                      itemCount: categoriesModel.data!.data.length,
                  ),
                ) ,
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'New Products',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1/1.58,
              children:List.generate(model.data.products.length,
                (index) => buildGridProduct (model.data.products[index],context),
              ),

            ),
          ),
        ],
      ),
    );
  }
  Widget buildCategoryItem(DataModel model)=>Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(model.image!),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(.7),
        width: 100.0,
        child: Text(
          model.name!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:TextStyle(
            color: Colors.white,
          ) ,
        ),
      ),
    ],
  );

  Widget buildGridProduct (ProductModel model,context) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              width:double.infinity ,
              height: 200.0,
            ),
            if(model.discount !=0)
            Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 5.0,),
              child: Text('DISCOUNT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight:FontWeight.bold ,
                  height: 1.3,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${model.price.round()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight:FontWeight.bold ,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width:10.0 ,
                  ),
                  if(model.discount !=0)
                  Text(
                    '${model.oldPrice.round()}',
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
                          ShopCubit.get(context).changeFavorites(model.id!);
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
      );
}
