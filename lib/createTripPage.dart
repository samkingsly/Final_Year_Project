import 'package:flutter/material.dart';
import 'mongoDBManager.dart';

final _formKey = GlobalKey<FormState>();
class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {

  final tripNameTC = TextEditingController();
  final descriptionTC = TextEditingController();
  final dateTC = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? homePageData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    String name = homePageData!["Name"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Trip",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigoAccent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Define the height of the bottom border
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
        ),
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.0,),
                TextFormField(controller: tripNameTC,decoration: InputDecoration(labelText: "Trip Name :",focusColor: Colors.indigoAccent,),
                    validator: (data) => data!.isEmpty ? "Cannot be Empty!": null),
                SizedBox(height: 30.0,),
                Text("Description : ",style: TextStyle(fontSize: 17.0),),
                TextFormField(maxLines: 6,controller: descriptionTC,decoration: InputDecoration(focusColor: Colors.indigoAccent,border: OutlineInputBorder(),hintText: 'Type here...',),
                    validator: (data) => data!.isEmpty ? "Cannot be Empty!": null),
                SizedBox(height: 30.0,),
                TextFormField(
                  controller: dateTC,
                  decoration: InputDecoration(
                    labelText: "Date",
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    focusColor: Colors.indigoAccent,
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (data) => data!.isEmpty ? "Select Date!": null
                ),
                SizedBox(height: 50.0,),
                Row(
                  children: [
                    SizedBox(width: 80.0),
                    ElevatedButton(onPressed: (){
                      String tripName = tripNameTC.text;
                      String description = descriptionTC.text;
                      String date = dateTC.text;
                      if(tripName.isNotEmpty && description.isNotEmpty && date.isNotEmpty )
                        {
                          MongoDataBases.createTrip(name,tripName,description,date);
                        }
                      _formKey.currentState!.validate();
                    },
                        style: const ButtonStyle(
                          fixedSize:MaterialStatePropertyAll(Size(150.0, 50.0)),
                          backgroundColor: MaterialStatePropertyAll(Colors.indigoAccent),
                        ) ,
                        child:Text("Create",style: TextStyle(color: Colors.white,fontSize: 20.0),)
                    )
            
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _selectDate() async
  {
    DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now() ,firstDate: DateTime.now(), lastDate: DateTime(2100));
    if(date != null)
      {
        setState(() {
          dateTC.text = date.toString().split(" ")[0];
        });
      }
  }
}
