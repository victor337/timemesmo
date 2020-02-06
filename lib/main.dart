import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:timemesmo/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


void main() async {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: 'Time',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
        ),
        home: Splash()
      ),
    );
  }
}
