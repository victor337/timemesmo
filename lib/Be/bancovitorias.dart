import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class BancoVitorias extends StatelessWidget {

  final DocumentSnapshot snapshot;

  BancoVitorias(this.snapshot);


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Card(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
              
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/person-male.png")
                  ),
                  title: Text("Jogo: ${snapshot.data["Nome do jogo"]}", style: TextStyle(color: Colors.black),),
                  trailing: Text("Resultado ${snapshot.data["Resultado"]}", style: TextStyle(color: Colors.black),),
                  onTap: (){}
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Campo: ${snapshot.data['Campo']}", style: TextStyle(color: Colors.black),),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text("Placar: ", style: TextStyle(color: Colors.white,),),
                          Text("${snapshot.data["Gols do time"]}", style: TextStyle(color: Colors.green, fontSize: 20),),
                          Text(" x ", style: TextStyle(color: Colors.black)),
                          Text(snapshot.data["Gols do adversário"], style: TextStyle(color: Colors.red, fontSize: 20 ))
                        ],
                      ),
                    )
                  ],
                )
              ],
            )
          )
        ),
        SizedBox(height: 5,)
      ],
    );
  }
}