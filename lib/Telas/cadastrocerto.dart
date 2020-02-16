import 'package:timemesmo/Telas/login.dart';
import 'package:timemesmo/controles/home_screen.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class CadastroCerto extends StatefulWidget {
  @override
  _CadastroCertoState createState() => _CadastroCertoState();
}

class _CadastroCertoState extends State<CadastroCerto> {
  
  TextEditingController nome = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  

  sucesso(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Criado com sucesso!", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  falha(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar!", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      )
    );

  }

    

    dialogo(){
      showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text("Atenção!"),
          content: Text("Imagem é obrigatória!", style: TextStyle(fontSize: 20),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        brightness: Brightness.dark,
      ),
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
                            child: Text("Criando conta\nAguarde um Momento"),
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
                        Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nome,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "Seu nome"
                          ),
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } return null;
                          },
                        ),
                        TextFormField(
                          controller: time,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "Nome do time"
                          ),
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } return null;
                          },
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 20),
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
                        TextFormField(
                          controller: senha,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "Senha"
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha!";
                            } else if(text.length <= 6){
                              return "Deve conter ao menos 6 caracteres";
                            } return null;
                          },
                        ),
                      ],
                    )
                  ),
                      ],
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

                          Map<String, dynamic> userData = {
                            "Nome": nome.text,
                            "Nome do time": time.text,
                            "Email": email.text,
                          };
                          model.criarConta(userData, senha.text, sucesso, falha);
                          model.saveUserData(userData);
                        }
                    },
                    child: Text("Criar conta", style: TextStyle(color: Colors.white, fontSize: 20),),
                )
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(height: 1, color: Colors.black, width: 100,),
                    Text("ou", style: TextStyle(color: Colors.white, fontSize: 15),),
                    Container(height: 1, color: Colors.black, width: 100,),
                  ],
                ),
                Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: Text("Clique abaixo para entrar na sua conta", style: TextStyle(color: Colors.white, fontSize: 22),),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login())
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)
                        ),
                        child: Center(child: Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 15)),),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}