import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/screens/home_page.dart';
import 'package:to_do_app/screens/login_page.dart';
import 'package:to_do_app/screens/onBoarding_page.dart';
import 'package:to_do_app/screens/splash.dart';
import 'package:to_do_app/screens/start_page.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyCustomWidget(),
    );
  }
}
