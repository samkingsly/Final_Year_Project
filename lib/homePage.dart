import 'package:finalyear_project_trial1/createTripPage.dart';
import 'package:flutter/material.dart';
import 'mongoDBManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 3),(){
      setState(() {
        _isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? loginPageData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    String name = loginPageData!["Name"];

    MongoDataBases.homePageData(name);

    List<Map<String,dynamic>>? defaultData = DataVariables.defaultTripMongoData;
    List<Map<String,dynamic>>? verifiedData = DataVariables.verifiedTripMongoData;
    List<Map<String,dynamic>>? usersData = DataVariables.usersTripMongoData;

    return DefaultTabController(
        length: 3,
        child: Scaffold(

          appBar: AppBar (
            title: const Text("Home"),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30.0),
            backgroundColor: Colors.indigoAccent,
            bottom: const TabBar(tabs:[
              Tab(child: Text("Default",style: TextStyle(color: Colors.white)),),
              Tab(child: Text("Verified",style: TextStyle(color: Colors.white)),),
              Tab(child: Text("Users",style: TextStyle(color: Colors.white)),)
            ]),
          ),

          body:_isLoading
          ?const Center(child: CircularProgressIndicator(),)
          :TabBarView(
              children:[
                //Default Trips
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  child:ListView.builder(
                    itemCount:defaultData?.length,
                    itemBuilder: (context, index){
                      Map<String,dynamic> x = defaultData![index];
                      return Padding(
                          padding: EdgeInsets.only(left: 10.0,right: 10.0),
                          child: Card(
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10.0,),
                                      CircleAvatar(backgroundImage: NetworkImage(x["Picture"]),radius: 20.0,),
                                      SizedBox(width: 15.0,),
                                      Container(width:125,child: Text(x["TripName"],style: TextStyle(fontSize: 15.0),)),
                                      SizedBox(width: 50.0,height: 70.0,),
                                      Text("Ratings: ${x["Rating"]}")
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ),
                      );
                    },
                  ),
                ),

                //Verified Trips
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  child:ListView.builder(
                    itemCount: verifiedData?.length,
                    itemBuilder: (context, index){
                      Map<String,dynamic> y = verifiedData![index];
                      return Padding(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10.0,),
                                    CircleAvatar(backgroundImage: NetworkImage(y["Picture"]),radius: 20.0,),
                                    SizedBox(width: 15.0,),
                                    Container(width:125,child: Text(y["TripName"],style: TextStyle(fontSize: 15.0),)),
                                    SizedBox(width: 50.0,height: 70.0,),
                                    Container(
                                      child:Column(
                                        children: [
                                          Text("Ratings: ${y["Rating"]}"),
                                          SizedBox(height: 10.0,),
                                          Text("Price: ${y["Price"]}"),
                                        ],
                                      ) ,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ),
                      );
                    },
                  ),
                ),


                //Users Trips
                Scaffold(
                  body: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child:ListView.builder(
                      itemCount: usersData?.length,
                      itemBuilder: (context, index){
                        Map<String,dynamic> z = usersData![index];
                        String fav = z["Favourites"] ? "*":"";
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/itineraryList",arguments: {"itineraryId" : z["ItineraryId"]});

                          },
                          child: Card(
                            elevation: 4 ,
                              child: Container(
                                height: 175.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10.0
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(image: NetworkImage(z["Picture"]),fit: BoxFit.fill)
                                ),
                                child:Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: [
                                            SizedBox(width: 20.0,),
                                            Container(width:300.0,child: Text(z["TripName"],style: TextStyle(fontSize: 15.0))),
                                            Text(fav)
                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Container(height:30.0,child: Text(z["Description"],style: TextStyle(fontSize: 10.0,color: Colors.grey))),
                                        Text("Date: ${z["Date"]}")
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            ),
                        );
                      },
                    ),
                  ),
                    floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushNamed(context,'/createTrip',arguments: {"Name": name});},
                      child: Text("+"),
                    )
                ),
              ]
          ),
        ),
    );
  }
}
