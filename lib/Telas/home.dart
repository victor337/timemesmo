import 'package:timemesmo/Be/banco.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_admob/firebase_admob.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    myInterstitial
    ..load()
    ..show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );

      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Todos").getDocuments(),
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
                      margin: EdgeInsets.only(top: 20, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 20, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 20, left: 8, right: 8),
                      child: ListView(
                      children: <Widget>[
                        Ataque(),
                        Meia(),
                        Defesa(),
                        TodosJogadores(),
                      ],
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

class Ataque extends StatefulWidget {
  @override
  _AtaqueState createState() => _AtaqueState();
}

class _AtaqueState extends State<Ataque> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Ataque").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.data.documents.length == 0 || snapshot.data.documents.length == null){
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/sword.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Ataque", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: <Widget>[
                        
                        Card(child: Container(padding: EdgeInsets.all(10), child: Text("Ainda não há jogadores nesta posição", style: TextStyle(color:Colors.blue)),))
                        
                      ],
                    ),
                    );
        }
        else {
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/sword.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Ataque", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: snapshot.data.documents.map(
                                (doc){
                                  return Banco(doc);
                                }).toList(),
                    ),
                    );
        }
      },
    );
      },
    );
  }
}

class Meia extends StatefulWidget {
  @override
  _MeiaState createState() => _MeiaState();
}

class _MeiaState extends State<Meia> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Meia").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)
            ),
          );
        }
        else if(snapshot.data.documents.length == 0 || snapshot.data.documents.length == null){
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/meio.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Meia", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: <Widget>[
                        Card(child: Container(padding: EdgeInsets.all(10), child: Text("Ainda não há jogadores nesta posição", style: TextStyle(color:Colors.blue))))
                        
                      ],
                    ),
                    );
        }
        else {
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/meio.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Meia", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: snapshot.data.documents.map(
                                (doc){
                                  return Banco(doc);
                                }).toList(),
                    ),
                    );
        }
      },
    );
      }
    );
  }
}

class Defesa extends StatefulWidget {
  @override
  _DefesaState createState() => _DefesaState();
}

class _DefesaState extends State<Defesa> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Defesa").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)
            ),
          );
        }
        else if(snapshot.data.documents.length == 0 || snapshot.data.documents.length == null){
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/shield.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Defesa", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: <Widget>[
                        Card(child: Container(padding: EdgeInsets.all(10), child: Text("Ainda não há jogadores nesta posição", style: TextStyle(color:Colors.blue))))
                        
                      ],
                    ),
                    );
        }
        else {
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/shield.png")),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Defesa", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: snapshot.data.documents.map(
                                (doc){
                                  return Banco(doc);
                                }).toList(),
                    ),
                    );
        }
      },
    );
      }
    );
  }
}

class TodosJogadores extends StatefulWidget {
  @override
  _TodosJogadoresState createState() => _TodosJogadoresState();
}

class _TodosJogadoresState extends State<TodosJogadores> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Todos").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)
            ),
          );
        }
        else if(snapshot.data.documents.length == 0 || snapshot.data.documents.length == null){
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                        leading: CircleAvatar(child: Image.asset("assets/jogadores.png"),),
                            trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Todos", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: <Widget>[
                        Card(child: Container(padding: EdgeInsets.all(10), child: Text("Ainda não há jogadores nesta posição", style: TextStyle(color:Colors.blue))))
                        
                      ],
                    ),
                    );
        }
        else {
          return Container(
                      padding: EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: Colors.blue,
                          trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                          leading: CircleAvatar(child: Image.asset("assets/jogadores.png"),),
                      title: Card(       
                        elevation: 5,     
                        color: Colors.blue,                        
                        child: Text("Todos", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      children: snapshot.data.documents.map(
                                (doc){
                                  return Banco(doc);
                                }).toList(),
                    ),
                    );
        }
      },
    );
      },
    );
  }
}


MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['football', 'game'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);



InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-4735870394464769/2267007201",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);