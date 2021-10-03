import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/network/dio_helper.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/shop_app/components/constants.dart';
import 'package:shop_app/shop_app/search/cubit/states.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit(SearchStates initialState) : super(SearchInitState());
   static SearchCubit get(context) => BlocProvider.of(context);

   SearchModel? model ;

   void search(String txt){
     emit(SearchLoadingState());
     DioHelper.postData(
         url: SEARCH,
         token:token ,
         data: {
           'text':txt,
         }
     ).then((value) {
       model = SearchModel.fromJson(value.data);
       emit(SearchSuccessState());
     }).catchError((error){
       print(error.toString());
       emit(SearchErrorState(error.toString()));
     });
   }
}