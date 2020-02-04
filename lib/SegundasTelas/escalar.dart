import 'package:timemesmo/SegundasTelas/historico.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


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

  TextEditingController controllador = TextEditingController();
  TextEditingController campo = TextEditingController();
  TextEditingController timeadv = TextEditingController();
  TextEditingController jogo = TextEditingController();


  void resetCamps(){
      controllador.text = "";
      campo.text = "";
      timeadv.text = "";
      jogo.text = "";
      setState(() {
        _itemResultdo = "Vitória";
        _itemSelecionadodeles = "0";
        _itemSelecionadonosso = "0";
      });
    }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Jogadores").getDocuments(),
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
                
                void criarJogo(String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo
                  });
                }

                void criarJogoGanho(String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Ganhos").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo
                  });
                }

                void criarJogoPerdido(String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Perdidos").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo
                  });
                }

                void criarJogoEmpate(String user, String jogo, String resultado, String campo, String timeadv, String golstime, String golsadv,){
                  Firestore.instance.collection("Usuarios").document(user).collection("Empates").document(jogo.toString()).setData({
                    "Campo": campo,
                    "Gols do time": golstime,
                    "Gols do adversário": golsadv,
                    "Resultado": resultado,
                    "Nome do jogo": jogo
                  });
                }

                void criarJoga(String user, String jogo, List jogadores){
                  for (var item in jogadores) {
                    Firestore.instance.collection("Usuarios").document(user).collection("Historico").document(jogo.toString()).collection("Jogadores").document(item).setData(
                      {
                        "Nome": item
                      }
                    );
                  }
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
                        padding: EdgeInsets.all(10),
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
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: snapshot.data.documents.map(
                              (doc){
                                return BancoEscalar(doc);
                              }).toList(),
                                )
                            ),
                            Container(
                              
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
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
                                    cursorColor: Colors.red,
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
                                    cursorColor: Colors.red,
                                    keyboardType: TextInputType.text,
                                    validator: (text){
                                      if (text.isEmpty){
                                        return "Preencha!";
                                      } return null;
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: jogo,
                                    decoration: InputDecoration(
                                      hintText: "Nome do jogo (Seu time vs Outro time)",
                                    ),
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.red,
                                    keyboardType: TextInputType.text,
                                    validator: (text){
                                      if (text.isEmpty){
                                        return "Preencha!";
                                      } return null;
                                    }, 
                                  ),
                                ],
                              )
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 40,
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
                                } else{
                                  if(_itemResultdo == "Vitória"){
                                  criarJogoGanho(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJogo(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                  resetCamps();
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Historico())
                                  );
                                } else if(_itemResultdo == "Derrota"){
                                  criarJogoPerdido(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJogo(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                  resetCamps();
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Historico())
                                  );
                                } else {
                                  criarJogoEmpate(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJogo(model.firebaseUser.uid,jogo.text, _itemResultdo, controllador.text, timeadv.text, _itemSelecionadonosso, _itemSelecionadodeles);
                                  criarJoga(model.firebaseUser.uid,jogo.text, jogadores);
                                  resetCamps();
                                  Navigator.pop(context);
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
                              height: 40,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: RaisedButton(
                              color: Colors.red,
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("Cancelar jogo", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              onPressed: (){
                                resetCamps();
                                Navigator.pop(context);
                              },
                            ),
                            )
                          ],
                        ),
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
          color: Colors.blue,
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
                  title: Text(snapshot.data["Nome"], style: TextStyle(color: Colors.white),),
                  trailing: Text("Nº ${snapshot.data['Nº da camisa']}", style: TextStyle(color: Colors.white),),
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
                    Text("Escalação: ${snapshot.data['Escalado']}", style: TextStyle(color: Colors.white),),
                    Text("Posição ${snapshot.data['Posição']}", style: TextStyle(color: Colors.white),),
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