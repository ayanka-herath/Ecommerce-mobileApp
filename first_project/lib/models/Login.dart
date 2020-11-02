//import 'package:first_project/main.dart';
import 'package:first_project/models/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'models/book.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import 'BookfirebaseDemo.dart';

class Login extends StatefulWidget
{
  static const routeName='/login';
  @override
  LoginScState createState() => LoginScState();
}

class LoginScState extends State<Login>
{
  final GlobalKey<FormState> formkey = GlobalKey();
  Map<String, String> authData = {
    'email':'',
    'password':''
  };
  void showerrormsg(String msg)
  {
    showDialog(
      context: context,
      builder: (ctx)=> AlertDialog(
        title:Text('An Error Occured'),
        content:Text(msg),
        actions:<Widget>[
          FlatButton(
            child:Text('OK'),
            onPressed:()
            {
              Navigator.of(ctx).pop();
            }
          )
        ]
      )
    );
  }
  Future<void> submit() async
  {
    if(!formkey.currentState.validate())
    {
      return;
    }
    formkey.currentState.save();
    try{
      await Provider.of<Authentication>(context, listen: false).logIn(authData['email'],authData['password']);
       Navigator.of(context).pushReplacementNamed(BookfirebaseDemo.routeName);
    }
    catch(e)
    {
      var errormsg = 'Authentication failed.Please Try again later';
      showerrormsg(errormsg);
    }
    
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions:<Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Signup'),
                Icon(Icons.person_add)
              ],
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(SignUp.routeName);
            },
          )
        ],
      ),
    body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.grey,

              ]
            )

          ),
        ),
      Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        child: Container(
          height:260,
          width:300,
          padding:EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //For input decorations for email
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator:(value)
                    {
                      //check email text is empty or wrong
                      if(value.isEmpty || !value.contains('@'))
                      {
                        return 'invalid email';
                      }

                      return null;

                    },
                    onSaved: (value)
                    {
                      authData['email']=value;
                    },
                  ),
                //password
                TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    
                    validator:(value)
                    {
                      //check email text is empty or wrong
                      if(value.isEmpty || value.length<=5)
                      {
                        return 'invalid password';
                      }

                      return null;

                    },
                    onSaved: (value)
                    {
                      authData['password']=value;
                    },
                  ),
                  SizedBox(
                    height: 30,

                  ),
                RaisedButton(
                  child: Text(
                    'Submit'
                  ),
                  onPressed:()
                  {
                      submit();
                  },
                  shape:RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
                  ),
                  color:Colors.blueAccent,
                  textColor: Colors.white,
                )
                ],
              ),
            )
          ),
        )
        )
      )
      ],
    ),
    );
  }
}