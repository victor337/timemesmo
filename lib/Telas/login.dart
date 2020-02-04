import 'package:timemesmo/Telas/cadastrocerto.dart';
import 'package:timemesmo/Telas/recuperar_senha.dart';
import 'package:timemesmo/controles/home_screen.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  sucesso(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Logado com sucesso!", style: TextStyle(color: Colors.white),),
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
        content: Text("Falha ao entrar!", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.white),),
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
                            child: Text("Acessando conta\nAguarde um Momento"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RecuperarSenha())
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 25, top: 10, bottom: 10, right: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)
                        ),
                        child: Text("Esqueci a senha", style: TextStyle(color: Colors.blue, fontSize: 20)),
                      ),
                    )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                        model.entrarConta(email.text, senha.text, sucesso, falha);
                      }
                      
                    },
                    child: Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 20),),
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
                  margin: EdgeInsets.all(10),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: Text("Clique abaixo para se cadastrar", style: TextStyle(color: Colors.white, fontSize: 22),),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => CadastroCerto())
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
                        child: Center(child: Text("Cadastrar", style: TextStyle(color: Colors.white, fontSize: 15)),),
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