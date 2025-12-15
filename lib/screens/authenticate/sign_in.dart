import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn ({this.toggleView});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>(); 
  bool loading = false;


  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor:Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            onPressed: () => widget.toggleView!(), 
            label: Text('Register'))
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
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null){
                      
                      setState(() {
                        error = 'Wrong Credentials';
                        loading=false;
                        });
                    }
                  } 
                },
                child: Text(
                  'Sign In',
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


// Sign in Anonimously (put it in child of padding)
// ElevatedButton(
//           onPressed: () async {
//             dynamic result = await _auth.signInAnon();
//             if (result == null) {
//               print('error signing in');
//             } else {
//               print('signed in');
//               print(result.uid);
//             }
//           }, 
//         child: Text('Sign In Anonimously')
//         ),