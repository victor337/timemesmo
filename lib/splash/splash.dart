import 'package:timemesmo/Telas/login.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



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
        return Scaffold(
          body: Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset('assets/splash.png', fit: BoxFit.contain)
            )
          ),
        );
      }      
    );
  }

  @override
  void initState() { 
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login())
          );
    });
    
  }  

}