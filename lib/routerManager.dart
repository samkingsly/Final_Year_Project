import 'package:flutter/material.dart';
import 'package:finalyear_project_trial1/loginPage.dart';
import 'package:finalyear_project_trial1/SignUpPage.dart';
import 'package:finalyear_project_trial1/homePage.dart';
import 'package:finalyear_project_trial1/createTripPage.dart';
import 'package:finalyear_project_trial1/itineraryListPage.dart';
import 'package:finalyear_project_trial1/createItineraryPage.dart';
void main()
{

  runApp(MaterialApp(

    initialRoute: "/login",

    routes: {
      '/login' : (context) => const LoginPage(),
      '/signup' : (context) => const SignUpPage(),
      '/home' : (context) => const HomePage(),
      '/createTrip': (context) => const CreateTripPage(),
      '/itineraryList' : (context) => const ItineraryListPage(),
      '/createItinerary' : (context) => const CreateItineraryPage(),
    },

  ));

}