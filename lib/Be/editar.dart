import 'package:firebase_admob/firebase_admob.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';


class EditarDados extends StatefulWidget {

  final DocumentSnapshot snapshot;

  EditarDados(this.snapshot);

  @override
  _EditarDadosState createState() => _EditarDadosState(snapshot);
}

class _EditarDadosState extends State<EditarDados> {

  final DocumentSnapshot snapshot;
  _EditarDadosState(this.snapshot);

  TextEditingController nome = TextEditingController();
  var cami = new MaskedTextController(mask: '00');
  var gols = new MaskedTextController(mask: '000');
  var cont = new MaskedTextController(mask: '(00) 00000-0000');

  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String escalado;
  var _opcao = ['Titular', 'Reserva'];
  var _itemSelecionado = 'Titular';
  var _nsei = ['Goleiro', 'Zagueiro', 'Lateral', 'Volante', 'Meio-Campo', 'Meia-Atacante', 'Atacante', 'Centroavante'];
  var _nsein = 'Meio-Campo';

  var _amareloopcoes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  var _amarelo = '0';

  var _vermelhoopcoes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  var _vermelho = '0';
  

  

  @override
  Widget build(BuildContext context) {

    
    dialogolo(nome){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Tudo certo!"),
          content: Text("O jogador $nome foi editado com sucesso! Aguarde enquanto atualizamos seu time", style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Ok"),
            )
          ],
        )
      );
    }
    
    void resetCamps(){
      nome.text = "";
      cont.text = "";
      cami.text = "";
      setState(() {
        _amarelo = "0";
        _vermelho = "0";
      });
    }

    void sendImgSt(int amarelo, int vermelho, String user, int gols, String nome, String posi, String esca, String numero, String camisa,)async{

      Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection("Todos").document(snapshot.data["Nome"]).updateData(
        {
          "Nome": nome,
          "Posição": posi,
          "Nº da camisa": camisa,
          "Escalado": esca,
          "Contato": numero,
          "Gols": gols,
          "Amarelos": amarelo,
          "Vermelhos": vermelho
        }
        );

        String pos;
        
        if(snapshot.data["Posição"] == "Goleiro" || snapshot.data["Posição"] == "Zagueiro" || snapshot.data["Posição"] == "Lateral"){
          pos = "Defesa";
        }
        else if(snapshot.data["Posição"] == "Volante" || snapshot.data["Posição"] == "Meio-Campo" || snapshot.data["Posição"] == "Meia-Atacante"){
          pos = "Meia";
        }
        else{
          pos = "Ataque";
        }

        Firestore.instance.collection("Usuarios").document(user).collection("Time").document("Jogadores").collection(pos).document(snapshot.data["Nome"]).updateData(
        {
          "Nome": nome,
          "Posição": posi,
          "Nº da camisa": camisa,
          "Escalado": esca,
          "Contato": numero,
          "Gols": gols,
          "Amarelos": amarelo,
          "Vermelhos": vermelho
        }
        );

    }

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Editar", style: TextStyle(color: Colors.white, fontSize: 22),),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/fundofundo.jpeg", fit: BoxFit.cover,),
              ),      
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white
                        ),
                        child: Column(
                        children: <Widget>[
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DropdownButton<String>(
                            items: _opcao.map((String dropDownStringItem){
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (String novoValor){
                              setState(() {
                                this._itemSelecionado = novoValor;
                              });
                            },
                            value: _itemSelecionado,
                          ),
                          DropdownButton<String>(
                            items: _nsei.map((String sdropDownStringItem){
                              return DropdownMenuItem<String>(
                                value: sdropDownStringItem,
                                child: Text(sdropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (String snovoValor){
                              setState(() {
                                this._nsein = snovoValor;
                              });
                            },
                            value: _nsein,
                          ),
                        ],
                      ),
                        ],
                      ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                          children: <Widget>[
                            TextFormField(
                            controller: nome,
                          decoration: InputDecoration(
                            hintText: "Novo nome",
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          validator:(text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } return null;
                          },
                        ),
                        SizedBox(height: 25,),
                        TextFormField(
                          controller: cont,
                          decoration: InputDecoration(
                            hintText: "Novo contato",
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } return null;
                          },
                        ),
                        SizedBox(height: 25,),
                        TextFormField(
                            controller: cami,
                          decoration: InputDecoration(
                            hintText: "Nº da camisa",
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            }
                            else if (text.isNotEmpty){
                              int nume = int.parse(text);
                              if(nume <= 0 || nume >= 100){
                                return "Digite um número de 1 à 99";
                              } 
                              
                            } return null;
                          } ,
                        ),
                        SizedBox(height: 25,),
                        TextFormField(
                            controller: gols,
                          decoration: InputDecoration(
                            hintText: "Gols do jogador",
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            }
                            return null;
                          } ,
                        ),
                          ],
                        )
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white
                        ),
                        child: Column(
                        children: <Widget>[
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Amarelos"),
                              SizedBox(width: 10),
                              DropdownButton<String>(
                                items: _amareloopcoes.map((String dropDownStringItem){
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem),
                                  );
                                }).toList(),
                                onChanged: (String novoValor){
                                  setState(() {
                                    this._amarelo = novoValor;
                                  });
                                },
                                value: _amarelo,
                              ),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: <Widget>[
                              Text("Vermelhos"),
                              SizedBox(width: 10),
                              DropdownButton<String>(
                                items: _vermelhoopcoes.map((String sdropDownStringItem){
                                  return DropdownMenuItem<String>(
                                    value: sdropDownStringItem,
                                    child: Text(sdropDownStringItem),
                                  );
                                }).toList(),
                                onChanged: (String snovoValor){
                                  setState(() {
                                    this._vermelho = snovoValor;
                                  });
                                },
                                value: _vermelho,
                              ),
                            ],
                          )
                        ],
                      ),
                        ],
                      ),
                      ),
                        SizedBox(height: 25,),
                      Container(
                        height: 45,
                        child: RaisedButton(
                        elevation: 5,
                        color: Colors.blue,
                        onPressed: (){
                          if(_formkey.currentState.validate()){
                              String jogador = nome.text;
                              String contato = cont.text;
                              String ncamisa = cami.text;
                              int novo = int.parse(gols.text);
                              int amarelo = int.parse(_amarelo);
                              int vermelho = int.parse(_vermelho);
                              
                              sendImgSt(amarelo, vermelho, model.firebaseUser.uid, novo, jogador, _nsein, _itemSelecionado, contato, ncamisa,);
                              resetCamps();
                              dialogolo(jogador);
                              myInterstitial
                              ..load()
                              ..show(
                                anchorType: AnchorType.bottom,
                                anchorOffset: 0.0,
                                horizontalCenterOffset: 0.0,
                              );
                            }
                          
                        },
                        child: Text("Editar", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      ),
                    ],
                  ),
                ),
              )
            ],
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