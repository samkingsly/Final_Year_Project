import 'package:finalyear_project_trial1/mongoDBManager.dart';
import 'package:flutter/material.dart';

class CreateItineraryPage extends StatefulWidget {
  const CreateItineraryPage({super.key});

  @override
  State<CreateItineraryPage> createState() => _CreateItineraryPageState();
}

class _CreateItineraryPageState extends State<CreateItineraryPage> {

  late bool _isLoading;
  bool _isCountryInitialized = false;
  bool _isRegionInitialized = false;
  String? countryVal;
  String? regionVal;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 5),(){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    MongoDataBases.countryGetter();
    List<String>? countriesList = DataVariables.countriesList ;
    String? countryValue;
    String? regionValue;
    if(!_isCountryInitialized)
      {
        countryValue = "";
        _isCountryInitialized = true;
      }
    else
      {
        countryValue = countryVal;
      }


    return Scaffold(
      appBar: AppBar(
        title: Text("Itinerary",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigoAccent,
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 100.0,),

          Text("Country",style: TextStyle(fontSize: 20.0,color: Colors.grey),),

          Center(
            child: Container(
              child: countriesList == null || countriesList.isEmpty
              ?Container()
              :Container(
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white,
                      width: 10.0
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<String>(
                  value: countryValue,
                  icon:  Icon(Icons.arrow_drop_down),
                  items: countriesList.map<DropdownMenuItem<String>>((String value)
                    {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }
                  ).toList(),

                  onChanged: (String? newValue){
                    setState(() {
                      countryVal = newValue;
                      print(countryValue);
                    });
                  },
                ),
              )
            ),
          ),
          SizedBox(height: 20.0,),

          Text("Region",style: TextStyle(fontSize: 20.0,color: Colors.grey),),

        ],
      ),

    );
  }
}
