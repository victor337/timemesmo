import 'package:timemesmo/Telas/dadosdojogador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Banco extends StatelessWidget {

  final DocumentSnapshot snapshot;

  Banco(this.snapshot);



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(snapshot.data["img"]) == null ? AssetImage('assets/person-male.png') : NetworkImage(snapshot.data["img"]),
              ),
              title: Text(snapshot.data["Nome"]),
              trailing: Text("${snapshot.data['Posição']} [${snapshot.data['Escalado']}]"),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DadosJogador(snapshot))
                );
              }
            ),
          )
        ),
        SizedBox(height: 5,)
      ],
    );
  }
}