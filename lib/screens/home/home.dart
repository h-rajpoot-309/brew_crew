import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'brew_list.dart';
import 'package:brew_crew/models/brew.dart';
//import 'package:brew_crew/screens/home/brew_tile.dart';


class Home extends StatelessWidget {
  
  final AuthService _auth = AuthService(); 


  @override
  Widget build(BuildContext context) {
    //final brews = Provider.of<List<Brew>>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }


    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Creww', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth .signOut();
                },
                icon: Icon(Icons.person, color: Colors.black,),
                label: Text('logout', style: TextStyle(color: Colors.black),),
              ),
              TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings, color: Colors.black),
                label: Text('Settings', style: TextStyle(color: Colors.black),),
                )
          
          ],
          
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.fitHeight
            )
          ),
          child: BrewList()
        ) 
    //     ListView.builder(
    //       itemCount: brews.length,
    //       itemBuilder: (context, index) {
    //         return BrewTile(brew: brews[index]);
    //       },
    // ),
      ),
    );
  }
}