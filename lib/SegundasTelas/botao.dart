import 'package:timemesmo/Telas/login.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:scoped_model/scoped_model.dart';


class Botao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return SpeedDial(
          child: Icon(Icons.list, color: Colors.white,),
          backgroundColor: Colors.blue,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              onTap: (){
                model.sairConta();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              },
              child: Icon(Icons.exit_to_app, color: Colors.blue,),
              backgroundColor: Colors.white,
              label: "Sair da conta",
              labelStyle: TextStyle(fontSize: 14)
            ),
          ],
        );
      },
    );
  }
}