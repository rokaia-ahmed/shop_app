import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/ShopLayout/shop_layout.dart';
import 'package:shop_app/network/cache_helper.dart';
import 'package:shop_app/register/cubit/cubit.dart';
import 'package:shop_app/register/cubit/states.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/shop_app/components/constants.dart';

class ShopRegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener:(context ,state){
          if(state is ShopRegisterSuccessState){
            if(state.loginModel!.status!){
              print(state.loginModel!.message);
              print(state.loginModel!.data!.token);

              CacheHelper.saveData
                (
                  key: 'token',
                  value: state.loginModel!.data!.token,
              ). then((value) {
                token =  state.loginModel!.data!.token!;
                navigationAndFinish(context,ShopLayout());
              });

            }else
            {
              print(state.loginModel!.message);
              showToast(
                  text: state.loginModel!.message!,
                  state: ToastStates.error
              );
            }
          }
        } ,
        builder:(context ,state){
          return  Scaffold(
            appBar: AppBar(),
            body:Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key:formKey ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text('register now to brows our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameController ,
                          validator: ( value) {
                            if(value!.isEmpty) {
                              return 'please enter your user name' ;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'user name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController ,
                          validator: ( value) {
                            if(value!.isEmpty) {
                              return 'please enter your email address' ;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'email address',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController ,
                          validator: ( value) {
                            if(value!.isEmpty) {
                              return 'please enter your phone' ;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'phone',
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          obscureText:ShopRegisterCubit.get(context).isPassword ,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController ,
                          validator: ( value) {
                            if(value!.isEmpty) {
                              return 'password is short' ;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(ShopRegisterCubit.get(context).suffix),
                              onPressed:(){
                                ShopRegisterCubit.get(context).changePasswordVisibility();
                              } ,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BuildCondition(
                          condition: state is! ShopRegisterLoadingState ,
                          builder: (context)=> Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.blue,
                            ),
                            width: double.infinity,
                            child:  MaterialButton(
                              onPressed:(){
                                if(formKey.currentState!.validate()){
                                  ShopRegisterCubit.get(context).userRegister(
                                      name:nameController.text,
                                      email: emailController.text,
                                      password:passwordController.text,
                                    phone:phoneController.text ,
                                  );
                                }
                              },
                              child: Text('Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),

                            ),
                          ),
                          fallback: (context)=> Center(child: CircularProgressIndicator()),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
}
