import 'package:flutter/material.dart';
import 'Building.dart';
import 'Excels.dart';
import 'Home.dart';
import 'LoadImages.dart';
import 'Reports.dart';
import 'generateSchema.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      routes: {
        "/home": (context) => Home(),
        "/Excels": (context) => Excels(),
        "/building": (context) => Building(),
        "/loadImages": (context) => LoadImages(),
        "/generateSchema": (context) => GenerateSchema(),
        "/Reports": (context) => Reports(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController loginController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Login Page",
            style: TextStyle(color: Theme.of(context).indicatorColor),
          ),
          backgroundColor: Colors.orange[800]
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            width: 400,
            height: 400,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("images/camusat.png"),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: loginController,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.mail),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: pwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String username = loginController.text;
                        String pwd = pwdController.text;
                        if (username == "admin" && pwd == "1234") {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, "/Excels");
                        }
                      },
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).indicatorColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
