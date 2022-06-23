import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristask/db/user_cache.dart';
import 'package:ristask/pages/task_home_page.dart';
import 'package:ristask/pages/task_splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({this.user, Key? key}) : super(key: key);
  String? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ristask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartingPage(),
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  String? user;
  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    user = await UserCache.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return user == null 
      ? TaskSplashPage()
      : TaskHomePage(
          user: user!,
        );
  }
}