import 'package:timemesmo/Be/bancohistorico.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class Historico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text("Histórico (Resumo)", style: TextStyle(color: Colors.white, fontSize: 22),),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Historico").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset("assets/historico-resumo.jpg",
                        fit: BoxFit.cover,),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      )
                    ],
                  );
                } 
                else if (snapshot.data.documents.length == 0) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/historico-resumo.jpg",
                        fit: BoxFit.cover,),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Text(
                                "Por enquanto nada.\nAdicione Jogos!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                          ),
                          )
                        ),
                      )
                    ],
                  );
                }
                else 
                {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset("assets/historico-resumo.jpg", fit: BoxFit.cover,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: ListView(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: snapshot.data.documents.map(
                              (doc){
                                return BancoHistorico(doc);
                              }).toList().reversed.toList(),
                                )
                              )
                            ],
                          ),
                      )
                    ],
                  );
            }
          },
        )
        );
      },
    );
  }
}