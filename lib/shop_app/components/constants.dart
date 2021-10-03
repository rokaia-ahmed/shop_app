import 'package:shop_app/login/login_screen.dart';
import '../../network/cache_helper.dart';
import 'Components.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value)
      navigationAndFinish(context,ShopLoginScreen());
  });
}

void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token ='';

