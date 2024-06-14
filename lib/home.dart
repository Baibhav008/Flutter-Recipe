import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:recipe/RecipeView.dart';
import 'package:recipe/model.dart';
import 'package:recipe/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController searchController = new TextEditingController();
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;


  bool isLoading = true;

  List<RecipeModel> recipeList = <RecipeModel>[];
  List reciptCatList=[
    {"imgUrl":"https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D","heading":"Indian Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1518133299975-8e1b628e1cfd?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1687020835890-b0b8c6a04613?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D","heading":"Tandoori"},
    {"imgUrl":"https://images.unsplash.com/photo-1551024709-8f23befc6f87?q=80&w=1914&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D","heading":"Drinks"},
    {"imgUrl":"https://images.unsplash.com/photo-1543773495-2cd9248a5bda?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D","heading":"Sweets"}];

  Future<void> getRecipe(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=2014e6af&app_key=0f0f8602a2b9e503230838036228a2a9";
    var response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    if(data["count"]==0)
    {
      MotionToast.warning(description:Text( "Dish Not Found")).show(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      setState(() {
        isLoading=false;
      });
    }
    data["hits"].forEach((element) {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 10));
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

    getRecipe("chicken");

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
        // Container for gradient

        //Complete Body
        SingleChildScrollView(
          child: Column(
            children: [

              //Search Bar
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

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(searchController.text.toString())));
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(searchController.text.toString())));
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What do you want to cook today",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: reciptCatList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            return Container(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(reciptCatList[index]["heading"])));
                                },
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(0, 10, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 4.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(reciptCatList[index]["imgUrl"],height: 250,width: 200,fit: BoxFit.cover,),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        top: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                          decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(20)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(reciptCatList[index]["heading"],style: TextStyle(
                                                  color: Colors.white,fontSize: 28
                                              ),),

                                            ],
                                          ),

                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );

                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Lets cook something new",
                        style: TextStyle(fontSize: 28, color: Colors.white))
                  ],
                ),
              ),
              Container(
                child: isLoading ?  Container(margin: EdgeInsets.fromLTRB(0, 200, 0, 0),alignment: Alignment.center,child: SpinKitWaveSpinner(color: Colors.greenAccent,size: 100,waveColor: Colors.blueAccent,),):
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeList.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index)
                    {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeView(recipeList[index].appUrl.toString())));
                        },
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
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
                                            Text(recipeList[index].appCalories.toString().substring(0,6)),
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
