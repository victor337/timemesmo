import 'package:timemesmo/Telas/login.dart';
import 'package:timemesmo/controles/home_screen.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';



class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        model.pegar();
        return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: model.firebaseUser == null ? Login() : HomeScreen(),
      image: new Image.asset('assets/splash.png'),
      title: Text('Iniciando', style: TextStyle(color: Colors.white, fontSize: 20),),
      backgroundColor: Colors.blue,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 250.0,
      loaderColor: Colors.white
    );
      }
    );
  }

}