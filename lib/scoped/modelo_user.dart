import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {


  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  

  bool carregando = false;

  int pegarnum;

  notify()async{
    notifyListeners();
  }


  pegarUidDoUsuario()async{
    await FirebaseAuth.instance.currentUser().then((user){

      firebaseUser = user;
      notifyListeners();

    }).catchError((erro){
      firebaseUser = null;
      notifyListeners();
    });
  }

  

  void criarConta(Map<String, dynamic> userData, String pass, VoidCallback sucesso, VoidCallback falha){
    
    carregando = true;
    notifyListeners();
    

    FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: userData["Email"],
    password: pass).then((auth)async{
    
      firebaseUser = auth.user;

      await saveUserData(userData);

      sucesso();
      carregando = false;
      notifyListeners();

    }).catchError((erro){
      falha();
      carregando = false;
      notifyListeners();
    });
  }
  
  void sairConta()async{
    await FirebaseAuth.instance.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void entrarConta(String email, String pass, VoidCallback sucesso, VoidCallback falha){
    carregando = true;
    notifyListeners();
    
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass).then((auth){
      firebaseUser = auth.user;
      sucesso();
      carregando = false;
      notifyListeners();
    }).catchError((erro){
      falha();
      carregando = false;
      notifyListeners();
    });


  }

  void recuperarPass(String email){
    carregando = true;
    notifyListeners();
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    carregando = false;
    notifyListeners();
  }

  bool estaLogado(){
    return firebaseUser != null;
  }
 
  Future<Null> saveUserData(Map<String, dynamic> userData)async{
    this.userData = userData;
    await Firestore.instance.collection("Usuarios").document(firebaseUser.uid).setData(userData);
  }

}