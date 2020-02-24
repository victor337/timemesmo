import 'package:firebase_admob/firebase_admob.dart';
import 'package:timemesmo/SegundasTelas/historico.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

List<String> jogadores = List();


class Escalar extends StatefulWidget {

  @override
  _EscalarState createState() => _EscalarState();
}

class _EscalarState extends State<Escalar> {

  var _nossaopcao = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
  var _itemSelecionadonosso = "0";

  var _opcaodeles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
  var _itemSelecionadodeles = "0";

  var _resultado = ["Vitória", "Derrota", "Empate"];
  var _itemResultdo = "Vitória";

  final _formkey = GlobalKey<FormState>();

  TextEditingController controllador = TextEditingController();
  TextEditingController campo = TextEditingController();
  TextEditingController timeadv = TextEditingController();
  TextEditingController jogo = TextEditingController();
  DateTime dataSelecionada;


  void resetCamps(){
      controllador.text = "";
      campo.text = "";
      timeadv.text = "";
      jogo.text = "";
      jogadores = [];
      setState(() {
        _itemResultdo = "Vitória";
        _itemSelecionadodeles = "0";
        _itemSelecionadonosso = "0";
        dataSelecionada = null;
      });
    }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Time").document("Jogadores").collection("Todos").getDocuments(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Adicionar jogo", style: TextStyle(color: Colors.white)),
                    centerTitle: true,
                    backgroundColor: Colors.blue,
                  ),
                  body: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
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
                ),
                );
              } 
              else if (snapshot.data.documents.length == 0){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Adicionar", style: TextStyle(color: Colors.white),),
                    centerTitle: true,
                    backgroundColor: Colors.blue,
                  ),
                  body: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
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
                              "Necessário adicionar jogadores!",
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
                ),
                );
              }
              else 
              {
                
                void criarJogo(DateTime data, String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo,
                    "Data": DateFormat('dd/MM/y').format(data).toString()
                  });
                }

                void criarJogoGanho(DateTime data, String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Ganhos").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo,
                    "Data": DateFormat('dd/MM/y').format(data).toString()
                  });
                }

                void criarJogoPerdido(DateTime data, String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Perdidos").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo,
                    "Data": DateFormat('dd/MM/y').format(data).toString()
                  });
                }

                void criarJogoEmpate(DateTime data, String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Empates").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo,
                    "Data": DateFormat('dd/MM/y').format(data).toString()
                  });
                }

                void criarJoga(String user, String jogo, List jogadores){
                  for (var item in jogadores) {
                    Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(jogo.toString()).collection("Jogadores").document(item).setData(
                      {
                        "Nome": item,
                      }
                    );
                  }
                }

                selecionarData(){
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime.now()
                    ).then((data){
                      if(data == null){
                        return;
                      }
                      else{
                        setState(() {
                          dataSelecionada = data;
                        });
                      }
                    });
                }

                dialogo(){
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      title: Text("Time de fantasmas?"),
                      content: Text("Adicione jogadores!", style: TextStyle(fontSize: 20),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Ok"),
                        )
                      ],
                    )
                  );
                }

                dialogoData(){
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      title: Text("Dia"),
                      content: Text("Adicione um dia para o seu jogo", style: TextStyle(fontSize: 20),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Ok"),
                        )
                      ],
                    )
                  );
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text("Adicionar jogo", style: TextStyle(color: Colors.white),),
                    centerTitle: true,
                    backgroundColor: Colors.blue,
                  ),
                  body: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/campo.jpg", fit: BoxFit.cover,),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Form(
                          key: _formkey,
                          child: ListView(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Center(
                              child: Text("Clique em quem jogou"),
                            ),
                            )
                          ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: ExpansionTile(
                              backgroundColor: Colors.blue,
                              leading: CircleAvatar(child: Image.asset("assets/jogadores.png"),),
                              trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
                              title: Card(       
                                elevation: 5,     
                                color: Colors.blue,                        
                                child: Text("Jogadores", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              children: snapshot.data.documents.map(
                                  (doc){
                                    return BancoEscalar(doc);
                                  }).toList(),                            
                            ),
                          ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Atenção"),
                                  SizedBox(height: 5),
                                  Text("Os jogos não podem ter o mesmo nome, caso adicione um jogo cujo o nome já exista, ele será substituido pelo novo", textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1)
                              ),
                              child: TextFormField(
                                    controller: jogo,
                                    decoration: InputDecoration(
                                      hintText: "Nome do jogo",
                                      hintStyle: TextStyle(color: Colors.white),
                                      labelStyle: TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.only(left: 10),
                                      suffixStyle: TextStyle(color: Colors.white)
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    keyboardType: TextInputType.text,
                                    validator: (text){
                                      if (text.isEmpty){
                                        return "Preencha!";
                                      } return null;
                                    }, 
                                  ),
                            ),
                            Container(                              
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton<String>(
                                            items: _resultado.map((String dropDownStringItem){
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child: Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                            onChanged: (String novoValor){
                                              setState(() {
                                                this._itemResultdo = novoValor;
                                              });
                                            },
                                            value: _itemResultdo,
                                          ),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text("Gols do time"),
                                          SizedBox(height: 5,),
                                          DropdownButton<String>(
                                            items: _nossaopcao.map((String dropDownStringItem){
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child: Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                            onChanged: (String novoValor){
                                              setState(() {
                                                this._itemSelecionadonosso = novoValor;
                                              });
                                            },
                                            value: _itemSelecionadonosso,
                                          ),
                                        ],
                                      ),
                                      Text("X", style: TextStyle(fontSize: 30),),
                                      Column(
                                        children: <Widget>[
                                          Text("Gols do adversário"),
                                          SizedBox(height: 5,),
                                          DropdownButton<String>(
                                            items: _opcaodeles.map((String dropDownStringItem){
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child: Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                            onChanged: (String novoValor){
                                              setState(() {
                                                this._itemSelecionadodeles = novoValor;
                                              });
                                            },
                                            value: _itemSelecionadodeles,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: controllador,
                                    decoration: InputDecoration(
                                      hintText: "Campo", 
                                    ),
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.blue,
                                    keyboardType: TextInputType.text,
                                    validator: (text){
                                      if (text.isEmpty){
                                        return "Preencha!";
                                      } return null;
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: timeadv,
                                    decoration: InputDecoration(
                                      hintText: "Qual nome do time adversário?",
                                    ),
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.blue,
                                    keyboardType: TextInputType.text,
                                    validator: (text){
                                      if (text.isEmpty){
                                        return "Preencha!";
                                      } return null;
                                    },
                                  ),
                                  SizedBox(height: 10,),                                  
                                ],
                              )
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(                                        
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Center(
                                          child: Text(dataSelecionada == null ? "Nenhuma data selecionada"
                                          : DateFormat('dd/MM/y').format(dataSelecionada).toString(), style: TextStyle(color: Colors.blue),),
                                        ),
                                      )
                                    ),
                                    SizedBox(width: 10),
                                    FlatButton(
                                      color: Colors.blue,
                                      onPressed: selecionarData,
                                      child: Text("Selecionar data", style: TextStyle(color: Colors.white),)
                                      )
                                  ],
                                ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 60,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: RaisedButton(
                              color: Colors.blue,
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("Criar jogo", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              onPressed: (){
                                if(jogadores.length == 0){
                                  dialogo();
                                }
                                if(dataSelecionada == null){
                                  dialogoData();
                                }
                                if(_formkey.currentState.validate()){
                                  if(_itemResultdo == "Vitória"){
                                    criarJogoGanho(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJogo(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                    resetCamps();
                                    Navigator.pop(context);
                                    myInterstitial
                                      ..load()
                                      ..show(
                                        anchorType: AnchorType.bottom,
                                        anchorOffset: 0.0,
                                        horizontalCenterOffset: 0.0,
                                      );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => Historico())
                                    );
                                } else if(_itemResultdo == "Derrota"){
                                    criarJogoPerdido(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJogo(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                    resetCamps();
                                    Navigator.pop(context);
                                    myInterstitial
                                      ..load()
                                      ..show(
                                        anchorType: AnchorType.bottom,
                                        anchorOffset: 0.0,
                                        horizontalCenterOffset: 0.0,
                                      );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => Historico())
                                    );
                                } else {
                                    criarJogoEmpate(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJogo(dataSelecionada, model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                    criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                    resetCamps();
                                    Navigator.pop(context);
                                    myInterstitial
                                      ..load()
                                      ..show(
                                        anchorType: AnchorType.bottom,
                                        anchorOffset: 0.0,
                                        horizontalCenterOffset: 0.0,
                                      );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => Historico())
                                    );
                                }
                                }
                                
                                
                              },
                            ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 60,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: RaisedButton(
                              color: Colors.red,
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("Cancelar jogo", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              onPressed: (){
                                resetCamps();
                                myInterstitial
                                      ..load()
                                      ..show(
                                        anchorType: AnchorType.bottom,
                                        anchorOffset: 0.0,
                                        horizontalCenterOffset: 0.0,
                                      );
                                Navigator.pop(context);
                              },
                            ),
                            )
                          ],
                        ),
                        )
                  )
                ],
              ),
                );
          }
        },
      );
      },
    );
  }
}

class BancoEscalar extends StatelessWidget {

  

  final DocumentSnapshot snapshot;

  BancoEscalar(this.snapshot);

  
  @override
  Widget build(BuildContext context) {


    
    



    dialogo(){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Atenção!"),
          content: Text("Jogador já selecionado", style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                jogadores.remove(snapshot.documentID);
                Navigator.pop(context);
                
              },
              child: Text("Remover", style: TextStyle(color: Colors.red),),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Ok"),
            )
          ],
        )
      );
    }

    dialogodois(){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Adicionado!"),
          content: Text("${snapshot.data["Nome"]} foi adicionado com sucesso!",
          style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Ok"),
            )
          ],
        )
      );
    }

    

    return Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          elevation: 10,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(snapshot.data["img"]),
                  ),
                  title: Text(snapshot.data["Nome"], style: TextStyle(color: Colors.black),),
                  trailing: Text("Nº ${snapshot.data['Nº da camisa']}", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    if(jogadores.contains(snapshot.documentID)){
                      dialogo();
                      
                    } else {
                      
                      jogadores.add(snapshot.documentID.toString());
                      dialogodois();
                    }
                  }
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Escalação: ${snapshot.data['Escalado']}", style: TextStyle(color: Colors.black),),
                    Text("Posição ${snapshot.data['Posição']}", style: TextStyle(color: Colors.black),),
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