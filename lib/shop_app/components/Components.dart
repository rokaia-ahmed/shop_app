import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shop_app/cubit/cubit.dart';

Widget myDivider() => Container(
  width: double.infinity,
  height: 1,
  color: Colors.grey,
);

void navigationAndFinish(context ,widget){
  Navigator.pushReplacement(
      context, MaterialPageRoute(
      builder: (context)=> widget,
  ),
       result: (Route <dynamic>route) => false,


  );
}
//*********************
 void showToast({
   required String text,
   required ToastStates state,
 })=>
     Fluttertoast.showToast(
     msg:text ,
     toastLength: Toast.LENGTH_LONG,
     gravity: ToastGravity.BOTTOM,
     timeInSecForIosWeb: 5,
     backgroundColor: shoosToastColor(state),
     textColor: Colors.white,
     fontSize: 16.0
 );
//enum
enum ToastStates{success, error ,warning}

Color shoosToastColor(ToastStates state){
  Color color ;
   switch(state)
      {
     case  ToastStates.success :
     color = Colors.green ;
     break;
     case  ToastStates.error :
       color = Colors.red ;
       break;
     case  ToastStates.warning:
       color = Colors.yellow ;
       break;

      }
      return color ;
}

//************************

void navigateTo( BuildContext context, Widget widget){
  Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

//*********************************
Widget defaultFormField(
    {
      required controller,
      required  type,
      onSubmitt,
      onChange,
      onTap,
      bool isclickable= true,
      bool isPassword=false,
      required validate,
      required label,
      required prefix,
      suffix,
      suffixpressed,

    }
    )=>TextFormField(
  keyboardType:type,
  controller: controller,
  onFieldSubmitted: onSubmitt,
  obscureText: isPassword,
  onChanged: onChange
  ,validator:validate,
  onTap: onTap,
  enabled: isclickable,
  decoration: InputDecoration(
    labelText:label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix!=null?IconButton(
        onPressed: suffixpressed ,
        icon: Icon(suffix)):null,
    border: OutlineInputBorder(),
  ),
);
//*************************************
Widget defaultButton(
    {
      double width = double.infinity,
      Color background = Colors.blue,
      required  String text,
      required Function function,
      double radius=6.0,
      bool isUpperCase = true,
    }
    ) =>Container(
        width:width,
         height: 50.0,
       child: MaterialButton(
           onPressed:(){
             function();
    },
         child:Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      radius,
    ),
    color: background,
  ),
);
//******************************************
Widget buildListProduct( model,context,{bool isOldPrice = true})=> Padding(
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
            if(model.discount !=0 && isOldPrice)
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
                  if(model.discount !=0 && isOldPrice)
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
                  if(isOldPrice)
                  CircleAvatar(
                    radius: 15.0,
                    backgroundColor: ShopCubit.get(context).favorites[model.id]??false ? Colors.blue : Colors.grey,
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