
//import 'dart:html';

import 'package:first_project/models/login.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

//import 'models/Login.dart';
import 'models/BookfirebaseDemo.dart';
import 'models/signup.dart';
//import 'models/book.dart';
import 'models/authentication.dart';

import 'package:provider/provider.dart';
void main() => runApp(BookApp());
  


class BookApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider.value(value: Authentication(),)
        ],
          child: MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: 'test',
        home: Login(),
        //home: BookfirebaseDemo(),
        routes: {
          SignUp.routeName:(ctx)=>SignUp(),
          Login.routeName:(ctx)=>Login(),
          BookfirebaseDemo.routeName:(ctx)=>BookfirebaseDemo(),
        },
      ),
    );
  }
}



