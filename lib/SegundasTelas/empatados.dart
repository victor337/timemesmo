import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timemesmo/Be/bancoempates.dart';
import 'package:timemesmo/scoped/modelo_user.dart';

class Empatados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Empates").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Scaffold(
                appBar: AppBar(
                  title: Text("Empates", style: TextStyle(color: Colors.white),),
                  centerTitle: true,
                  backgroundColor: Colors.grey,
                ),
                body: Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                ),
              );
            }
            else if(snapshot.data.documents.length == 0){
              return Scaffold(
              appBar: AppBar(
                title: Text("Empates", style: TextStyle(color: Colors.white),),
                centerTitle: true,
                backgroundColor: Colors.grey,
              ),
              body: Container(
                child: Center(
                  child: Container(
                    color: Colors.grey,
                    padding: EdgeInsets.all(10),
                    child: Text("Você não tem nenhuma partida ganha", style: TextStyle(color:Colors.white),)
                  )
                ),
              ),
            );
            }
            else {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Empates", style: TextStyle(color: Colors.white),),
                  centerTitle: true,
                  backgroundColor: Colors.grey,
                ),
                body: Container(
                        padding: EdgeInsets.all(5),
                        child: ListView(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: snapshot.data.documents.map(
                              (doc){
                                return BancoEmpates(doc);
                              }).toList(),
                                )
                              )
                            ],
                          ),
                      )
                  );
            }
          },
        );
      },
    );
  }
}