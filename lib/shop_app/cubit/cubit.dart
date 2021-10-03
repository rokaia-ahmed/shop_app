
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_models.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_models.dart';
import 'package:shop_app/models/login_models.dart';
import 'package:shop_app/network/dio_helper.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/shop_app/categories/categories_screen.dart';
import 'package:shop_app/shop_app/components/constants.dart';
import 'package:shop_app/shop_app/cubit/states.dart';
import 'package:shop_app/shop_app/favorites/favorite_screen.dart';
import 'package:shop_app/shop_app/products/product_screen.dart';
import 'package:shop_app/shop_app/setting_screen.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit(ShopStates initialState) : super(ShopInitState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex =0;
  List<Widget> bottomScreens =[
    ProductScreen(),
    CategoriesScreen(),
    FavoriteScreen(),
    SettingScreen(),
  ];

  void changeBottom(int index){
    currentIndex = index ;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int,bool> favorites ={};
  void getHomeData(){
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
        url:HOME,
        token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //printFullText(homeModel!.data.banners[0].image!);
      // print(homeModel!.status);
      homeModel!.data.products.forEach((element) {
        favorites.addAll({
          element.id! : element.inFavorites!,
        });
      });

      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }
//***************************************
  CategoriesModel? categoriesModel;
  void getCategories(){

    DioHelper.getData(
      url:GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());

    }).catchError((error){
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }
  //********************************************
  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId){
    favorites[productId] =! favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url:FAVORITES ,
      token: token,
      data:{
        'product_id' : productId ,
      },
    ).
    then((value) {

      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);

      if(!changeFavoritesModel!.status!){
        favorites[productId] =! favorites[productId]!;
      }else{
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).
    catchError((error){
      favorites[productId] =! favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  //*************************************************

  FavoritesModel? favoritesModel;
  void getFavorites(){
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url:FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
     // printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());

    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  //***************************************************

  ShopLoginModel? userModel;
  void getUserData(){

    //print(token);
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url:PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
     // printFullText(userModel!.data!.name!);
      emit(ShopSuccessUserDataState(userModel!));

    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String? name,
    required String? email,
    required String? phone,
}){

    //print(token);
    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
      url:UPDATE_PROFILE,
      token: token,
      data:{
        'name':name ,
        'email':email ,
        'phone':phone ,
      } ,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
       printFullText(userModel!.data!.name!);
      emit(ShopSuccessUpdateUserDataState(userModel!));

    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUpdateUserDataState());
    });
  }

}
