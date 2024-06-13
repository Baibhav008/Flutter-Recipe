import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();

  List<RecipeModel> recipeList = <RecipeModel>[];
  List reciptCatList=[
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Indian Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"},
    {"imgUrl":"https://images.unsplash.com/photo-1593560704563-f176a2eb61db","heading":"Chilli Food"}];

  Future<void> getRecipe(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=2014e6af&app_key=0f0f8602a2b9e503230838036228a2a9";
    var response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
    });
    recipeList.forEach((Recipe) {
      print(Recipe.appLabel);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //getRecipe("maggie");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213D50), Color(0xff071938)])),
        ),
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
                            getRecipe(searchController.text);
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
                    SizedBox(
                      height: 10,
                    ),
                    Text("Lets cook something new",
                        style: TextStyle(fontSize: 28, color: Colors.white))
                  ],
                ),
              ),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeList.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index)
                    {
                      return InkWell(
                        onTap: () {},
                        child:
                        Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10))),
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

              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: reciptCatList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                    return Container(
                      child: InkWell(
                        onTap: (){},
                        child: Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0.0,
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
              )
            ],
          ),
        )
      ],
    ));
  }
}
