import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength; 
  
  @override
  Widget build(BuildContext context) {
  final user = Provider.of<UserId?>(context);

    return  StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, asyncSnapshot) {
        print('ConnectionState: ${asyncSnapshot.connectionState}');
        print('HasData: ${asyncSnapshot.hasData}');
        print('Doc data: ${asyncSnapshot.data}');  
        if(asyncSnapshot.hasData){
          UserData userdata = asyncSnapshot.data!;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
              Text(
                'Update your brew settings',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Name'),
                initialValue: userdata.name,
                validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height: 20.0),
              //dropdown
              DropdownButtonFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Enter the no of sugars'),
                initialValue: _currentSugars ?? userdata.sugars,
                items: sugars.map((sugar) {
                  return DropdownMenuItem(
                    value: sugar,
                    child: Text('$sugar sugars'),
                  );
                }).toList(), 
                onChanged: (value) => {setState(() => _currentSugars = value)}),
              //slider
              Slider(
                value: (_currentStrength ?? userdata.strength).toDouble(),
                activeColor: Colors.brown[_currentStrength ?? userdata.strength],
                inactiveColor: Colors.brown[_currentStrength ?? userdata.strength],
                min: 100,
                max: 900,
                divisions: 8,
                onChanged: (val) => setState(() => _currentStrength = val.round()),
          
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.pink),
                  ),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userdata.sugars,
                        _currentName ?? userdata.name,
                        _currentStrength ?? userdata.strength
                      );
                      Navigator.pop(context);
                    }
                    print(_currentName);
                    print(_currentSugars);
                    print(_currentStrength);
                },
              )
            ],
            )
          );
        } else {
            print(asyncSnapshot.data);
            return Loading();
        }
      }
    );
  }
}