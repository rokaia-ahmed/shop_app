import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/ShopLayout/on_boarding.dart';
import 'package:shop_app/ShopLayout/shop_layout.dart';
import 'package:shop_app/login/login_screen.dart';
import 'package:shop_app/shop_app/components/constants.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';
import 'package:shop_app/shop_app/cubit/states.dart';
import 'package:shop_app/theme.dart';
import 'network/cache_helper.dart';
import 'network/dio_helper.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');

 late Widget widget ;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
   token = CacheHelper.getData(key: 'token');
    print(token);

  if(onBoarding != null){
    if (token != null) widget= ShopLayout();
    else widget = ShopLoginScreen();
  }else{
    widget = OnBoardingScreen();
  }
  print(onBoarding);
  runApp(MyApp(
    isDark:isDark ,
    startWidget: widget,
  )
  );
}

class MyApp extends StatelessWidget {
  final  bool? isDark ;
  final  Widget? startWidget ;

 MyApp(
     {required this.isDark,
       required this.startWidget}
     );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (context)=> ShopCubit(ShopInitState())..getHomeData()..getCategories()..getFavorites()..getUserData(),
       ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:lightTheme ,
        darkTheme: darkTheme,
        home: startWidget ,
      ),
    );
  }
}

