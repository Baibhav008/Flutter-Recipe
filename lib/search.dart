import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:recipe/home.dart';
import 'package:recipe/model.dart';

import 'RecipeView.dart';

class Search extends StatefulWidget {

  String query;
  Search(this.query);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  TextEditingController searchController = new TextEditingController();

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  bool isLoading = true;

  List<RecipeModel> recipeList = <RecipeModel>[];
  List reciptCatList=[
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Indian Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"}];

  Future<void> getRecipe(String query) async {
    try{
      String url = "https://api.edamam.com/search?q=$query&app_id=2014e6af&app_key=0f0f8602a2b9e503230838036228a2a9";
      var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5),onTimeout: ()
      {
        MotionToast.warning(description:Text( "Dish Not Found")).show(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
        setState(() {
          isLoading=false;
        });
        return http.Response('Request timed out', 408);
      });
      Map data = jsonDecode(response.body);
      print(jsonDecode(response.body));
      if(data["count"]==0)
        {
          MotionToast.warning(description:Text( "Dish Not Found")).show(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          setState(() {
            isLoading=false;
          });
        }
      data["hits"].forEach((element)
      {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading=false;
        });
      });
      recipeList.forEach((Recipe) {
        print(Recipe.appLabel);
      });

    }catch(e)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 5));
    _topAlignmentAnimation=TweenSequence([
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft,end: Alignment.topRight), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight,end: Alignment.bottomRight), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight,end: Alignment.bottomLeft), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft,end: Alignment.topLeft), weight:1)
    ]).animate(_controller);

    _bottomAlignmentAnimation=TweenSequence([
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight,end: Alignment.bottomLeft), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft,end: Alignment.topLeft), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft,end: Alignment.topRight), weight:1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight,end: Alignment.bottomRight), weight:1)
    ]).animate(_controller);

    _controller.repeat();
    getRecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(animation: _controller, builder: (context,_){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blueAccent,Colors.greenAccent],
                      begin: _topAlignmentAnimation.value,
                      end: _bottomAlignmentAnimation.value),
                ),
              );
            }),
            SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      //Search Container
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),

                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("blank");
                              } else {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search(searchController.text.toString())));
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                )),
                          ),
                          Expanded(
                            child: TextField(
                              onSubmitted: (String x){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search(searchController.text.toString())));
                              },

                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search Recipe",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.blue[800]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    child: isLoading ? Container(margin: EdgeInsets.fromLTRB(0, 200, 0, 0),alignment: Alignment.center,child: SpinKitWaveSpinner(color: Colors.greenAccent,size: 100,waveColor: Colors.blueAccent,),):  ListView.builder(
                        shrinkWrap: true,
                        itemCount: recipeList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index)
                        {
                          return InkWell(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeView(recipeList[index].appUrl.toString())));},
                            child:
                            Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 4.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      recipeList[index].appImgUrl.toString(),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        decoration: BoxDecoration( borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                            color: Colors.black45
                                        ),
                                        child: Text(recipeList[index].appLabel.toString(),
                                          style: TextStyle(fontSize: 20,color: Colors.white),),
                                      )),
                                  Positioned(
                                      right: 0,
                                      height: 40,
                                      width: 80,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.local_fire_department,size: 18,),
                                                Text(
                                                  recipeList[index].appCalories.toString().length > 6
                                                      ? recipeList[index].appCalories.toString().substring(0, 6)
                                                      : recipeList[index].appCalories.toString(),
                                                )
                                              ],
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),


                ],
              ),
            )
          ],
        ));
  }
}
