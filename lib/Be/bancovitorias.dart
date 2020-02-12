import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timemesmo/scoped/modelo_user.dart';



class BancoVitorias extends StatelessWidget {

  final DocumentSnapshot snapshot;

  BancoVitorias(this.snapshot);


  @override
  Widget build(BuildContext context) {

    /*

    excluir(String user, String result){

      if(result == "Vitoria"){
        result = "Ganhos";
      } else if(result == "Derrota"){
        result = "Perdidos";
      } else{
        result = "Empates";
      }

      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Confirmação"),
          content: Text("Deseja realmente excluir? A ação não pode ser desfeita!", style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancelar",),
            ),
            FlatButton(
              onPressed: (){
                Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(snapshot.documentID).delete();
                Firestore.instance.collection("Usuarios").document(user).collection(result).document(snapshot.documentID).delete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.red),),
            )
          ],
        )
      );
    }

    */

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
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
      },
    );
  }
}