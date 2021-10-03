import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/shop_app/search/cubit/states.dart';
class SearchScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> SearchCubit(SearchInitState()),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener:(context, state){} ,
        builder:(context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key:formKey ,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        onSubmitt: (String text){
                          if(formKey.currentState!.validate()){
                            SearchCubit.get(context).search(text);
                          }
                        } ,
                        validate: (value){
                          if(value.isEmpty){
                            return 'enter text to search';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search,
                    ),
                    SizedBox(
                      height:10.0 ,
                    ),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),
                    SizedBox(
                      height:10.0 ,
                    ),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context ,index) {
                         return buildListProduct(
                              SearchCubit.get(context).model!.data!.data[index],context,isOldPrice: false) ;
                        },
                        separatorBuilder: (context ,index) =>myDivider() ,
                        itemCount: SearchCubit.get(context).model!.data!.data.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }

}
