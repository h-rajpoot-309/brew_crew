import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';


class Register extends StatefulWidget {
  final Function? toggleView;
  Register ({this.toggleView});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>(); 
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor:Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Brew Crew', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            onPressed: () => widget.toggleView!(),
            label: Text('Sign In'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Enter a password atleast 6 characters long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.pink),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()){
                    setState(() => loading=true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if (result == null){
                      setState(() {
                        error = 'Invalid email or password';
                        loading = false;
                        });
                    }
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
            ),
            SizedBox(height: 20.0),
            Text(
              error,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.0
              ),
            )
            ],
          ) 
          )
      ),
    );
  }
}