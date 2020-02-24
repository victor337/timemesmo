import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:timemesmo/Telas/login.dart';
import 'package:flutter/material.dart';
import 'package:timemesmo/controles/home_screen.dart';
import 'package:timemesmo/scoped/modelo_user.dart';



class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        model.pegarUidDoUsuario();
        print(model.firebaseUser);
        return SplashScreen(
          loaderColor: Colors.white,
          seconds: 4,
          title: Text("Iniciando", style: TextStyle(color: Colors.white, fontFamily: 'Raleway-Regular.ttf'),),
          image: Image.asset("assets/Meu-Timao.png"),
          photoSize: MediaQuery.of(context).size.height/4,
          backgroundColor: Colors.blue,
          navigateAfterSeconds: model.firebaseUser != null ? HomeScreen() : Login(),
        );
      }
    );
  }
}