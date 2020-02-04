
import 'dart:io';
import 'package:timemesmo/SegundasTelas/escalar.dart';
import 'package:timemesmo/SegundasTelas/historico.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';



class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  File imagem;

  void setImagem(File img){
      setState(() {
        imagem = img;
      });
    }

    void sendImgSt(String user, String brasao, File imgFile)async{

      StorageUploadTask task = FirebaseStorage.instance.ref().child(user).child(brasao)
      .child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);
      
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      

      Firestore.instance.collection("Usuarios").document(user).updateData({"img": url,});
      
      
    }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).get(),
          builder: (context, snapshot){
            if (!snapshot.hasData){
              return Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/tecnico.jpg", fit: BoxFit.cover),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset("assets/tecnico.jpg",
                    fit: BoxFit.cover,),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 15,),
                      Container(
                        padding: EdgeInsets.all(10),                
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(32)
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16),
                                              child: Column(
                                                children: <Widget>[
                                                  Text('Técnico',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                  ),
                                                  Text(snapshot.data["Nome"],
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Container(
                                              height: 140,
                                              width: 140,
                                              padding: EdgeInsets.all(5),
                                              child: GestureDetector(
                                                onTap: ()async{

                                                  if(snapshot.data["img"] == null) {
                                                    File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                    if(imgFile == null) return;
                                                    else{
                                                      setImagem(imgFile);
                                                    }
                                                  } else {
                                                    return null;
                                                  }
                                                  
                                                },
                                                child: Container(            
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(width: 1),
                                                    color: Colors.grey[300],
                                                  ),
                                                  child: snapshot.data["img"] == null ? Text("Envie uma foto") : Image.network(snapshot.data["img"], fit: BoxFit.cover,),
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              child: Text("Enviar foto"),
                                              onPressed: (){
                                                if(imagem == null){
                                                  return null;
                                                } else{
                                                  sendImgSt(model.firebaseUser.uid, "Brasão" , imagem);
                                                }
                                              }
                                            )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: Column(
                                                children: <Widget>[
                                                  Text('Following',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                  ),
                                                  Text('18',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10
                                          ),
                                          child: Text('ID: ${model.firebaseUser.uid.toString()}',
                                          style: TextStyle(
                                            color: Colors.white70
                                          ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 16, bottom: 32),
                                          child: Text(snapshot.data["Nome do time"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Ganhos(),
                                              Perdidos(),
                                              Empates()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                  ),
                                ],
                              ),
                            ),
                            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            
                            SizedBox(height: 10,),
                            Card(
                                  color: Colors.transparent,
                                  elevation: 10,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => Escalar())
                                        );
                                      },
                                      child: Text("ADICIONAR JOGO", style: TextStyle(color: Colors.white, fontSize: 23),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Card(
                                  color: Colors.transparent,
                                  elevation: 10,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => Historico())
                                        );
                                      },
                                      child: Text("HISTÓRICO DE JOGOS", style: TextStyle(color: Colors.white, fontSize: 23)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                          ],
                        ),
                      )
                    ],
                  ),
                  
                ],
              ),
                    ],
                  )
                )
              );
            }
          },
        );
      },
    );
  }
}

class Ganhos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Ganhos").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.data.documents.length == 0){
              return Column(
                  children: <Widget>[
                    Text("Vitórias", style: TextStyle(color: Colors.green),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
            }
            return Column(
                  children: <Widget>[
                    Text("Vitórias", style: TextStyle(color: Colors.green),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
          },
        );
      },
    );
  }
}

class Perdidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Perdidos").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapshot.data.documents.length == 0){
              return Column(
                  children: <Widget>[
                    Text("Vitórias", style: TextStyle(color: Colors.green),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
            }
            return Column(
                  children: <Widget>[
                    Text("Derrotas", style: TextStyle(color: Colors.red),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
          },
        );
      },
    );
  }
}

class Empates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Usuarios").document(model.firebaseUser.uid).collection("Empates").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapshot.data.documents.length == 0){
              return Column(
                  children: <Widget>[
                    Text("Vitórias", style: TextStyle(color: Colors.green),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
            }
            return Column(
                  children: <Widget>[
                    Text("Empates", style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 5),
                    Text(snapshot.data.documents.length.toString(), style: TextStyle(color: Colors.black),),
                  ],
                );
          },
        );
      },
    );
  }
}
