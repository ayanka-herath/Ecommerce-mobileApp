//import 'package:first_project/models/login.dart';
import 'package:first_project/models/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
//import 'models/book.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
//import 'package:provider/provider.dart';
//import 'package:first_project/main.dart';
import 'BookfirebaseDemo.dart';


class SignUp extends StatefulWidget
{
  static const routeName='/signup';
  @override
  SignUpScState createState() => SignUpScState();
}

class SignUpScState extends State<SignUp>
{
  final GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController passwordcontroller = new TextEditingController();
  
  Map<String, String> _authData = {
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
        await Provider.of<Authentication>(context, listen: false).signUp(_authData['email'],_authData['password']);
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
        title: Text('SingUp'),
        actions:<Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Login'),
                Icon(Icons.person)
              ],
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(Login.routeName);
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
                Colors.blueAccent,

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
          height:300,
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
                      _authData['email']=value;
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
                      _authData['password']=value;
                    },
                  ),
                  //PW confirmation
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    controller: passwordcontroller,
                    validator:(value)
                    {
                      //check email text is empty or wrong
                      if(value.isEmpty || value!=passwordcontroller.text)
                      {
                        return 'invalid password';
                      }

                      return null;

                    },
                    onSaved: (value)
                    {

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