import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/network/cache_helper.dart';
import 'package:shop_app/login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../shop_app/components/Components.dart';

class BoardingModel{
  late final String image ;
  late final String title ;
  late final String body ;
  BoardingModel({
   required this.image,
   required this.title,
   required this.body
});
}
class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List <BoardingModel> boarding =[
   BoardingModel(
     image: 'assets/images/shop.jpg',
     title: 'on board 1 title',
     body: 'on board 1 body',
   ),
   BoardingModel(
      image: 'assets/images/shop.jpg',
      title: 'on board 2 title',
      body: 'on board 2 body',
    ),
   BoardingModel(
      image: 'assets/images/shop.jpg',
      title: 'on board 3 title',
      body: 'on board 3 body',
    ),
  ];

  var boardController = PageController();

  bool isLast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value){
        navigationAndFinish(context,ShopLoginScreen(),);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (){
                submit();
              },
              child:Text(
                'SKIP'
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller:boardController ,
               itemBuilder:(context,index) =>buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int index){
                  if(index == boarding.length -1) {
                    setState(() {
                      isLast = true ;
                    });
                    print('last');
                  }else{
                    print('not last');
                    setState(() {
                      isLast = false ;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller:boardController ,
                    count:boarding.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                       spacing: 5.0,
                    ),
                ),
                Spacer(),
                FloatingActionButton(
                    onPressed:(){
                      if( isLast){
                        submit();
                      } else{
                        boardController.nextPage(
                          duration:Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }

                    },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Image(image:AssetImage('${model.image}'))),
      SizedBox(
        height: 30.0,
      ),
      Text('${model.title}',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text('${model.body}',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
