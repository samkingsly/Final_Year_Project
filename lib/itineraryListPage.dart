import 'package:flutter/material.dart';
import 'mongoDBManager.dart';
import 'dart:async';

class ItineraryListPage extends StatefulWidget {
  const ItineraryListPage({super.key});

  @override
  State<ItineraryListPage> createState() => _ItineraryListPageState();
}

class _ItineraryListPageState extends State<ItineraryListPage> {

  late bool _isLoading;
  List<dynamic>? itinerariesList;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 3),(){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? homePageData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    int itineraryId = homePageData!["itineraryId"];
    MongoDataBases.itineraryFetch(itineraryId);

    itinerariesList = DataVariables.itineraries;
    print(itinerariesList);
    return Scaffold(

      appBar: AppBar(
        title: Text("Plans",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigoAccent,
      ),

      body: _isLoading
      ?const Center(child: CircularProgressIndicator(),)
      :Scaffold(
        body:itinerariesList!.isEmpty
          ?Center(
            child: Container(
            child: ElevatedButton(onPressed: (){Navigator.pushReplacementNamed(context, "/createItinerary",arguments: {"itineraryId" : itineraryId});},
              child: Text("Add Region"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(20), // Adjust the padding as needed
              ),
            ),
                    ),
          )
          :ListView.builder(
          itemCount: itinerariesList?.length,
          itemBuilder: (context,index)
          {
            Map<String,dynamic> data = itinerariesList![index];
            return Card(
              elevation: 4 ,
              child: Container(
                  height: 175.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 10.0
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1682685797742-42c9987a2c34?q=80&w=20…"),fit: BoxFit.fill)
                  ),
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10.0,),
                          Text("${data["City"]}( ${data["Country"]} )"),
                          SizedBox(width: 60.0,),
                          ElevatedButton(onPressed: null,
                            child: const Row(children: [Text("Start",style: TextStyle(color: Colors.white),),Icon(Icons.navigation,color: Colors.white,)],),
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),),
                          SizedBox(width: 60.0,),
                          IconButton(onPressed: null, icon: Icon(Icons.edit))
                        ],
                      )
                    ),
                  )
              ),
            );

          },
        ),
      ),
    );
  }
}
