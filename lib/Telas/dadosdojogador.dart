import 'package:firebase_admob/firebase_admob.dart';
import 'package:timemesmo/Be/editar.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DadosJogador extends StatefulWidget {

  final DocumentSnapshot snapshot;
  DadosJogador(this.snapshot);

  @override
  _DadosJogadorState createState() => _DadosJogadorState(snapshot);
}

class _DadosJogadorState extends State<DadosJogador> {

  final DocumentSnapshot snapshot;
  _DadosJogadorState(this.snapshot);



  @override
  Widget build(BuildContext context) {

    dialogolo(String user){
      showModalBottomSheet(
        context: context,
        builder: (_){
          return Container(
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Tem certeza que deseja excluir?", style: TextStyle(fontSize: 22),),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: (){
                          Navigator.pop(context);
                          myInterstitial
                            ..load()
                            ..show(
                              anchorType: AnchorType.bottom,
                              anchorOffset: 0.0,
                              horizontalCenterOffset: 0.0,
                            );
                        },
                        child: Text("Cancelar ação!", style: TextStyle(color: Colors.white,)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: (){
                          Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Todos").document(snapshot.documentID).delete();
                          Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Ataque").document(snapshot.documentID).delete();
                          Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Meia").document(snapshot.documentID).delete();
                          Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Defesa").document(snapshot.documentID).delete();
                          myInterstitial
                            ..load()
                            ..show(
                            anchorType: AnchorType.bottom,
                            anchorOffset: 0.0,
                            horizontalCenterOffset: 0.0,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Desejo excluir!", style: TextStyle(color: Colors.white,)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        );
    }

  /*

    dialogolo(String user){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(25),
          title: Text("Tem certeza?"),
          content: Text("Se excluir o jogador não haverá como desfazer a ação!", style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            
          ],
        )
      );
    }

  */

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["Nome"], style: TextStyle(fontSize: 25, color: Colors.white,)),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditarDados(snapshot))
                  );
                },
                child: Text("Editar", style: TextStyle(color: Colors.white, fontSize: 18),),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset("assets/perfilnovo.jpg", fit: BoxFit.cover,),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(snapshot.data["img"],),
                        )
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("Dados do jogador", style: TextStyle(fontSize: 25, color: Colors.white),),)
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 20,
                        margin: EdgeInsets.all(2),
                        child: Image.asset("assets/bola.png", fit: BoxFit.contain,),
                      ),
                      SizedBox(height: 10,),
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Escalação: ${snapshot.data["Escalado"]}", style: TextStyle(fontSize: 21),),
                              Divider(),
                              Text("Posição: ${snapshot.data["Posição"]}", style: TextStyle(fontSize: 21),),
                              Divider(),
                              Text("Nº ${snapshot.data["Nº da camisa"]}", style: TextStyle(fontSize: 21),),
                              Divider(),
                              Text("Gols marcados: ${snapshot.data["Gols"].toString()}", style: TextStyle(fontSize: 21),),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    child: Image.asset("assets/cartao-amarelo.png", fit: BoxFit.cover,),
                                  ),
                                  Text(snapshot.data["Amarelos"].toString(), style: TextStyle(fontSize: 21),)
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    child: Image.asset("assets/cartao-vermelho.png", fit: BoxFit.cover,),
                                  ),
                                  Text(snapshot.data["Vermelhos"].toString(), style: TextStyle(fontSize: 21),)
                                ],
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: (){
                                  launch("tel:${snapshot.data["Contato"]}");
                                  },
                                child: Text("Ctt: ${snapshot.data["Contato"]}", style: TextStyle(fontSize: 21, color: Colors.blue),),
                              ),                    
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(),
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          padding: EdgeInsets.all(12),
                          color: Colors.red,
                          onPressed: (){
                            dialogolo(model.firebaseUser.uid);
                            
                          },
                          child: Text("Deletar jogador", style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          )
        );
      },
    );
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['football', 'game'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  // Android emulators are considered test devices
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