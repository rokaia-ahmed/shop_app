
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app/components/Components.dart';
import 'package:shop_app/ShopLayout/shop_layout.dart';
import 'package:shop_app/network/cache_helper.dart';
import 'package:shop_app/login/cubit/states.dart';
import 'package:shop_app/register/register_screen.dart';
import 'package:shop_app/shop_app/components/constants.dart';
import 'cubit/cubit.dart';

class ShopLoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener:(context ,state){
          if(state is ShopLoginSuccessState){
            if(state.loginModel!.status!){
               print(state.loginModel!.message);
               print(state.loginModel!.data!.token);

                CacheHelper.saveData
                  (
                    key: 'token',
                    value: state.loginModel!.data!.token
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
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key:formKey ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text('login now to brows our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey
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
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          obscureText:ShopLoginCubit.get(context).isPassword ,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController ,
                          validator: ( value) {
                            if(value!.isEmpty) {
                              return 'password is short' ;
                            }
                          },
                          onFieldSubmitted:(value){
                              if(formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                          } ,

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                icon: Icon(ShopLoginCubit.get(context).suffix),
                                 onPressed:(){
                                   ShopLoginCubit.get(context).changePasswordVisibility();
                                 } ,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BuildCondition(
                          condition: state is! ShopLoginLoadingState ,
                          builder: (context)=> Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.blue,
                            ),
                            width: double.infinity,
                            child:  MaterialButton(
                              onPressed:(){
                                print(emailController);
                                print(passwordController);
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password:passwordController.text);
                                }
                              },
                              child: Text('Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),

                            ),
                          ),
                          fallback: (context)=> Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account'),
                            TextButton(onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder:(context)=>ShopRegisterScreen(), ),
                              );
                            },
                              child:Text('register now'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        } ,
      ),
    );
  }
}
