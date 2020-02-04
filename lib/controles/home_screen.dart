import 'package:timemesmo/SegundasTelas/botao.dart';
import 'package:timemesmo/Telas/addJogadores.dart';
import 'package:timemesmo/Telas/home.dart';
import 'package:timemesmo/Telas/menu.dart';
import 'package:timemesmo/scoped/modelo_user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController; 
  int _page = 0;

  @override
  void initState() { 
    super.initState();
    
  _pageController = PageController();

  }

  @override
  void dispose(){
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model){
        return Scaffold(
          floatingActionButton: Botao(),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.blue,
              primaryColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white54)
              )
            ),
            child: BottomNavigationBar(
              currentIndex: _page,
              onTap: (p){
                _pageController.animateToPage(
                  p, 
                  duration: Duration(milliseconds: 80),
                  curve: Curves.linear
                  );
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  title: Text('Jogadores')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  title: Text('Técnico')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  title: Text('Adicionar')
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (p){
              setState(() {
                _page = p;
              });
            },
          children: <Widget>[
            Home(),
            Menu(),
            AddJogadores(),
          ],
        ),
        );
      },
    );
  }
}