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
    }

    void sendImgSt(String user, int gols, String nome, String posi, String esca, String numero, String camisa,)async{

      Firestore.instance.collection("Usuarios").document(user).collection("Jogadores").document(snapshot.data["Nome"]).updateData(
        {
          "Nome": nome,
          "Posição": posi,
          "Nº da camisa": camisa,
          "Escalado": esca,
          "Contato": numero,
          "Gols": gols
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/fundofundo.jpeg", fit: BoxFit.cover,),
              ),      
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                          borderRadius: BorderRadius.circular(15)
                        ),
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
                              
                              sendImgSt(model.firebaseUser.uid, novo, jogador, _nsein, _itemSelecionado, contato, ncamisa,);
                              resetCamps();
                              dialogolo(jogador);
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