import 'package:timemesmo/Be/banco.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Jogadores").getDocuments(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/campo.jpg",
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
                      child: Image.asset("assets/campo.jpg",
                      fit: BoxFit.cover,),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Card(
                          color: Colors.blue,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.transparent,
                            child: Text(
                              "Por enquanto nada.\nAdicione Jogadores!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
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
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/campo.jpg", fit: BoxFit.cover,),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Container(padding: EdgeInsets.all(10), color: Colors.transparent, child: Text("Jogadores", style: TextStyle(color: Colors.white, fontSize: 20),),),
                      ),
                      children: snapshot.data.documents.map(
                                (doc){
                                  return Banco(doc);
                                }).toList(),
                    ),
                    )
                  ],
                );
          }
        },
      );
        },
      );
  }
}