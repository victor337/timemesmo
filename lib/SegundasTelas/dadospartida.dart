import 'package:firebase_admob/firebase_admob.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';




class DadosPartida extends StatefulWidget {

  final DocumentSnapshot snapshot;  

  DadosPartida(this.snapshot);

  @override
  _DadosPartidaState createState() => _DadosPartidaState(snapshot);

  
}

class _DadosPartidaState extends State<DadosPartida> {

  final DocumentSnapshot snapshot;

  _DadosPartidaState(this.snapshot);


    excluir(String user, String result){

      if(result == "Vitória"){
        result = "Ganhos";
      } else if(result == "Derrota"){
        result = "Perdidos";
      } else{
        result = "Empates";
      }

    showModalBottomSheet(
      context: context,
      builder: (_){
        return Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Deseja realmente excluir?", style: TextStyle(fontSize: 22),),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text("Cancelar", style: TextStyle(color:  Colors.white)),
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
                    )
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text("Confirmar", style: TextStyle(color:  Colors.white)),
                      onPressed: (){
                        Firestore.instance.collection("Usuarios").document(user).collection("$result").document(snapshot.documentID).delete();
                        Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(snapshot.documentID).delete();                        
                        Navigator.pop(context);
                        Navigator.pop(context);
                        myInterstitial
                          ..load()
                          ..show(
                            anchorType: AnchorType.bottom,
                            anchorOffset: 0.0,
                            horizontalCenterOffset: 0.0,
                            );

                      },
                    )
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
                Navigator.pop(context);
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.red),),
            )
          ],
        )
      );
    }

    */
  
  @override
  Widget build(BuildContext context) {

    
    
    dynamic cor = snapshot.data["Resultado"];
    if(cor == "Vitória"){
      cor = Colors.green;
    }
    else if(cor == "Empate"){
      cor = Colors.grey;
    }
    else{
      cor = Colors.red;
    }

    
    


    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["Nome do jogo"], style: TextStyle(color: Colors.white, fontSize: 25),),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/fut.jpg", fit: BoxFit.cover,),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Card(
                        color: Colors.white,
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("${snapshot.data["Resultado"]}", style: TextStyle(fontSize: 30, color: cor),),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("${snapshot.data["Gols do time"]}", style: TextStyle(fontSize: 25, color: Colors.blue),),
                                  Text(" x ", style: TextStyle(fontSize: 25, color: Colors.black),),
                                  Text("${snapshot.data["Gols do adversário"]}", style: TextStyle(fontSize: 25, color: Colors.red),),
                                ],
                              ),
                              Divider(),
                              Text("Campo: ${snapshot.data["Campo"]}", style: TextStyle(fontSize: 21),),
                              Divider(),
                              Text("Data: ${snapshot.data["Data"]}", style: TextStyle(fontSize: 21),)
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1)
                      ),
                      child: Center(
                        child: Text("Clique para adicionar\nGols e cartões", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white),),
                      )
                    ),
                    ListaJoga(snapshot),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: () { 
                        excluir(model.firebaseUser.uid, snapshot.data["Resultado"]);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(child: Text("EXCLUIR PARTIDA", style: TextStyle(color: Colors.white, fontSize: 20),),)
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        );
      },
    );
  }
}

class ListaJoga extends StatefulWidget {

  final DocumentSnapshot snapshot;
  ListaJoga(this.snapshot);

  
  @override
  _ListaJogaState createState() => _ListaJogaState(snapshot);

  
}

class _ListaJogaState extends State<ListaJoga> {

 final DocumentSnapshot snapshot;
  _ListaJogaState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Historico").document(snapshot.documentID).collection("Jogadores").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              }
            else if(snapshot.data.documents.length == 0){
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text("Os jogadores foram excluidos!")
                )
              );
            }
            else {
              return Column(
                children: snapshot.data.documents.map(
                  (doc){
                    return BancoDados(doc);
                  }).toList(),
                );
            }
      },
    );
      },
    );
  }
}

class BancoDados extends StatefulWidget {

  final DocumentSnapshot snapshot;
  BancoDados(this.snapshot);

  @override
  _BancoDadosState createState() => _BancoDadosState(snapshot);
}

class _BancoDadosState extends State<BancoDados> {
  
  final DocumentSnapshot snapshot;
  _BancoDadosState(this.snapshot);
  
 
  @override
  Widget build(BuildContext context) {

    TextEditingController teste = TextEditingController();
    TextEditingController amarelo = TextEditingController();
    TextEditingController vermelho = TextEditingController();

    final _formkey = GlobalKey<FormState>();

    

    addteste(int atual, int vermelhu, int amarelu, String user){
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
              key: _formkey,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Preencha as informações"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: teste,
                    decoration: InputDecoration(
                      hintText: "Gols"
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty){
                        return "Preencha! (se não houver coloque 0)";
                      } return null;
                    },
                  ),
                  TextFormField(
                    controller: amarelo,
                    decoration: InputDecoration(
                      hintText: "Amarelos"
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty){
                        return "Preencha! (se não houver coloque 0)";
                      } else if(int.parse(text) >= 3){
                        return "O máximo de amarelos por jogo são 2!";
                      } return null;
                    },
                  ),
                  TextFormField(
                    controller: vermelho,
                    decoration: InputDecoration(
                      hintText: "Vermelhos"
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty){
                        return "Preencha! (se não houver coloque 0)";
                      } else if(int.parse(text) >= 3){
                        return "O máximo de vermelhos por jogo são 1!";
                      } return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar",),
                      ),
                      FlatButton(
                        onPressed: (){
                          if(_formkey.currentState.validate()){
                            Navigator.pop(context);
                            int gols = int.parse(teste.text);
                            int vermelhocerto = int.parse(vermelho.text);
                            int amarelocerto = int.parse(amarelo.text);
                            amarelocerto += amarelu;
                            vermelhocerto += vermelhu;
                            gols += atual;
                            Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Todos").document(snapshot.documentID).updateData({
                              "Gols": gols,
                              "Amarelos": amarelocerto,
                              "Vermelhos": vermelhocerto
                            });
                            Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Ataque").document(snapshot.documentID).updateData({
                              "Gols": gols,
                              "Amarelos": amarelocerto,
                              "Vermelhos": vermelhocerto
                            });
                            Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Defesa").document(snapshot.documentID).updateData({
                              "Gols": gols,
                              "Amarelos": amarelocerto,
                              "Vermelhos": vermelhocerto
                            });
                            Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Meia").document(snapshot.documentID).updateData({
                              "Gols": gols,
                              "Amarelos": amarelocerto,
                              "Vermelhos": vermelhocerto
                            });
                            myInterstitial
                                      ..load()
                                      ..show(
                                        anchorType: AnchorType.bottom,
                                        anchorOffset: 0.0,
                                        horizontalCenterOffset: 0.0,
                                      );
                            Navigator.pop(context);
                            }
                        },
                        child: Text("Confirmar", style: TextStyle(color: Colors.green),),
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        )
      );
    }

    /*
    int _currentValue = 0;
    
    
    addgol(int atual){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Quantos gols?"),
          content: NumberPicker.integer(
                initialValue: 0,
                minValue: 0,
                maxValue: 10,
                onChanged: (newValue) =>
                    setState(() => _currentValue = newValue)),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancelar",),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                int gols = _currentValue;
                gols += atual;
                print(gols);
                print(atual);
                Firestore.instance.collection("Jogadores").document(snapshot.documentID).updateData({
                  "Gols": gols
                });
                
                
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.green),),
            )
          ],
        )
      );
    }
    */

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Todos").document(snapshot.documentID).get(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container();
        }
        else{
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
                backgroundImage: AssetImage("assets/jogadores.png"),
              ),
              title: Text(snapshot.data["Nome"]),
              onTap: (){
                addteste(snapshot.data["Gols"], snapshot.data["Vermelhos"], snapshot.data["Amarelos"], model.firebaseUser.uid); 
                }
            ),
          )
        ),
        SizedBox(height: 5,)
      ],
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
  adUnitId: "ca-app-pub-4735870394464769/3823174609",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);