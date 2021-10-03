import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app/components/constants.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';
import 'package:shop_app/shop_app/cubit/states.dart';

import 'components/Components.dart';

class SettingScreen extends StatelessWidget {
  final formKey= GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener:(context , state) {},
      builder:(context , state){
        var model = ShopCubit.get(context).userModel;
        if(model != null) {
          nameController.text = model.data!.name!;
          emailController.text = model.data!.email!;
          phoneController.text = model.data!.phone!;
        }
        return BuildCondition(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key:formKey ,
              child: Column(
                children: [
                  if(state is ShopLoadingUpdateUserDataState)
                  LinearProgressIndicator(),
                  SizedBox(
                    height:20.0 ,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (value){
                      if(value.isEmpty)
                      {
                        return 'name must not be empty';
                      }
                      return null ;
                    },
                    label: 'name',
                    prefix: Icons.person,

                  ),
                  SizedBox(
                    height:20.0 ,
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (value){
                      if(value.isEmpty)
                      {
                        return 'email must not be empty';
                      }
                      return null ;
                    },
                    label: 'Email Address',
                    prefix: Icons.email,

                  ),
                  SizedBox(
                    height:20.0 ,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (value){
                      if(value.isEmpty)
                      {
                        return 'phone must not be empty';
                      }
                      return null ;
                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(
                    height:20.0 ,
                  ),
                  defaultButton(
                      text:'UpDate' ,
                      function: (){
                        if(formKey.currentState!.validate())
                          {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                      }
                  ),
                  SizedBox(
                    height:20.0 ,
                  ),
                    defaultButton(
                        text:'LogOut' ,
                        function: (){
                          signOut(context);
                        }
                    ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      } ,
    );
  }
}
