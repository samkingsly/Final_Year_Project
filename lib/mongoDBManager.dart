import 'package:mongo_dart/mongo_dart.dart';
import 'package:finalyear_project_trial1/mongoDBConstant.dart';
import 'dart:developer';

class MongoDataBases
{
  static Db? _db;

  MongoDataBases._();

  static Future<Db> _getDB() async
  {
    if(_db == null)
      {
        _db = await Db.create(MongoDbUrl);
        await _db!.open();
      }
    return _db!;
  }

  static connect() async
  {
    await _getDB();
    inspect(_db);
  }

//region Authentication(Login)
  static Future<List> authentication(String name, String password) async
  {
    String redStringData = "";
    bool auth = false;

    final db = await _getDB();
    var collection = db.collection(usersCollection);
    final fetchedData = await collection.findOne(where.eq("Name",name));
    if(fetchedData == null)
    {
      redStringData = "Wrong Username";
    }
    if(fetchedData!=null)
    {
      final data = fetchedData;
      if(fetchedData["Password"] == password)
        {
          auth = true;
        }
      else
        {
          print(data["Password"]);
          auth = false;
          redStringData = "Wrong Password";
        }

    }
    return [redStringData, auth];
  }
  //endregion

//region Registration(SignUp)
  static Future<List> registration(String name, String password) async
  {
    String redStringData = "";
    bool confirm = false;

    final db = await _getDB();
    var collection = db.collection(userNameCollection);
    final fetchedUserName = await collection.findOne(where.eq("Name", name));
    if(fetchedUserName != null)
      {
        redStringData = " username already exists ";
      }
    else
      {
        var usernameC = db.collection(userNameCollection);
        var usersC = db.collection(usersCollection);

        Map<String,dynamic> x = {"Name":name};
        await usernameC.insertOne(x);
        Map<String,dynamic> y = {"Name":name,"Password":password};
        await usersC.insertOne(y);
        confirm = true;
      }

    return[redStringData,confirm];
  }
  //endregion

//region Home

  static Future<void> homePageData(String name) async
  {
    final db = await _getDB();
    var _usersTripCollection = db.collection(usersItinerariesCollection);
    var _defaultTripCollection = db.collection(defaultItinerariesCollection);
    var _verifiedTripCollection = db.collection(verifiedItinerariesCollection);

    final usersTripMongoData = await _usersTripCollection.find(where.eq("UserName", name)).toList();
    final verifiedTripMongoData = await _verifiedTripCollection.find().toList();
    final defaultTripMongoData = await _defaultTripCollection.find().toList();

    DataVariables.usersTripMongoData = usersTripMongoData;
    DataVariables.verifiedTripMongoData = verifiedTripMongoData;
    DataVariables.defaultTripMongoData = defaultTripMongoData;

}
//endregion

//region CreateTrip

static Future<void> createTrip(String name, String tripName, String description, String date) async
{
  int? highestId = await getHighestItineraryId();
  print(highestId);
  highestId = highestId! + 1;
  final db = await _getDB();
  var usersTripCollection = db.collection(usersItinerariesCollection);
  var systemDataCollection_ItineraryCount = db.collection(systemDataCollection);

  final filter = where.eq("ItineraryCount", highestId - 1);
  final update = modify.set("ItineraryCount", highestId);
  await systemDataCollection_ItineraryCount.update(filter, update);

  Map<String,dynamic> dataToInsert = {"TripName" : tripName, "Favourites" : false, "Date" : date, "Description": description,
                                      "UserName" : name,  "Picture" : "", "ItineraryId" : highestId};
  usersTripCollection.insertOne(dataToInsert);


}

static Future<int?> getHighestItineraryId() async
{
  int? highestId = 0;

  final db = await _getDB();
  var systemDataCollection_ItineraryCount = db.collection(systemDataCollection);

  Map<String,dynamic>? data = await systemDataCollection_ItineraryCount.findOne();
  highestId = data!["ItineraryCount"];
  return highestId;
}


//endregion

//region ItineraryGetter

static Future<void> itineraryFetch(int itineraryId) async
{
  final db = await _getDB();
  var itineraryInformationCollectionData = db.collection(itineraryInformationCollection);

  final idsPlan = await itineraryInformationCollectionData.findOne(where.eq("ItineraryId", itineraryId));
  if(idsPlan != null)
    {
      final itineraries = idsPlan["Itineraries"];
      DataVariables.itineraries = itineraries;
    }
  else
    {
      final itineraries = [];
      DataVariables.itineraries = itineraries;
    }

}

//endregion

//region createItinerary

static Future<void> countryGetter() async
{
  final db = await _getDB();
  var _countryAndRegionCollection = db.collection(countriesAndRegionsCollection);

  final data = await _countryAndRegionCollection.findOne();

  List<dynamic> countries = data!["Country"];
  DataVariables.countriesList = countries.cast<String>();


}

  static Future<void> regionGetter(String country) async
  {
    final db = await _getDB();
    var _countryAndRegionCollection = db.collection(countriesAndRegionsCollection);

    final data = await _countryAndRegionCollection.findOne();

    Map<String,dynamic> regions = data!["Regions"];
    List<dynamic> regionsData = regions[country];
    DataVariables.regionsList = regionsData.cast<String>();


  }

//endregion
}

class DataVariables
{
  //Home Page
  static List<Map<String,dynamic>>? usersTripMongoData ;
  static List<Map<String,dynamic>>? verifiedTripMongoData;
  static List<Map<String,dynamic>>? defaultTripMongoData;
  //createTripPage
  static List<dynamic>? itineraries;

  //createItineraryPage
  static List<String>? countriesList;
  static List<String>? regionsList;


}

