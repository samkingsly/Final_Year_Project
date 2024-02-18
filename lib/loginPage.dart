import 'package:flutter/material.dart';
import 'mongoDBManager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String redString = "";

  String name = "";
  String pass = "";

  final userTC = TextEditingController();
  final passTC = TextEditingController();

  @override
  void initState() {
    MongoDataBases.connect();
    super.initState();
  }

  @override
  void dispose() {
    userTC.dispose();
    passTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30.0),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            const Center(child: CircleAvatar(backgroundImage: AssetImage("Assets/Images/Logo.png"), radius: 125.0,backgroundColor: Colors.white,)),
            const SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
              child: TextField(controller: userTC ,decoration: const InputDecoration(label: Text("Name")),),
            ),
            const SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
              child: TextField(controller: passTC ,decoration: const InputDecoration(label: Text("Password")),),
            ),
            const SizedBox(height: 20.0,),
            Text(redString,style: const TextStyle(color: Colors.redAccent),),
            const SizedBox(height: 20.0,),
            ElevatedButton(
                onPressed:() async{
                  name = userTC.text;
                  pass = passTC.text;
                  List<dynamic> data = await MongoDataBases.authentication(name, pass);
                  if(data[1])
                    {
                      Navigator.pushReplacementNamed(context, "/home",arguments: {"Name":name});
                    }
                  else
                    {
                      setState(() {
                        redString = data[0];
                      });
                      Future.delayed(const Duration(seconds: 1),(){
                        setState(() {
                        redString = "";
                        });
                      });
                    }
                },
                style: const ButtonStyle(
                    fixedSize:MaterialStatePropertyAll(Size(150.0, 30.0)),
                    backgroundColor: MaterialStatePropertyAll(Colors.indigoAccent),
                ) ,
                child: const Text("Login",style: TextStyle(fontSize: 20.0,color: Colors.black),)),
            TextButton(onPressed: (){Navigator.pushReplacementNamed(context,'/signup');},
                child: const Text("don't have an account | SignUp",style: TextStyle(color: Colors.indigoAccent),)),
          ],
        ),
      ),

    );
  }
}

