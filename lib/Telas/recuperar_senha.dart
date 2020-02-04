import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {

  sucesso(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Enviado com sucesso!", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      )
    );
  }

  

  TextEditingController email = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  reset(){
    setState(() {
      email.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar senha", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      key: _scaffoldKey,
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.carregando){
            return Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/fundo-login.jpg", fit: BoxFit.cover,),
                  ),
                  Container(
                    child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.all(20),
                            child: Text("Enviando link\nAguarde um Momento"),
                          ),
                          SizedBox(height: 10,),
                          CircularProgressIndicator()
                        ],
                      ),
                  ),
                  )
                ],
              );
          } else {
            return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/fundo-login.jpg", fit: BoxFit.cover,),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Container(
                  
                  padding: EdgeInsets.all(10),
                    height: 150,
                    child: Center(
                    child: Image.asset("assets/bola.png", fit: BoxFit.cover,)
                  ),
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                    children: <Widget>[
                  SizedBox(height: 20,),
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: email,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "Email"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } return null;
                          },
                        ),
                      ],
                    )
                  ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                 Center(
                   child: Text("Clique no botão para enviar o link de recuperação para o email acima",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                 ),
                 SizedBox(height: 10,),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,                    
                    border: Border.all(width: 1)
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    elevation: 0,
                    color: Colors.blue,
                    onPressed: (){
                      if(_formkey.currentState.validate()){
                        model.recuperarPass(email.text);
                        sucesso();
                        reset();
                      }
                    },
                    child: Text("Enviar", style: TextStyle(color: Colors.white),),
                )
                ),
                SizedBox(height: 10,),
              ],
            ),
            )
          ],
        ),
      );
          }
        },
      ),
    );
  }
}