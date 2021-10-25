import 'dart:math';

import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      "My Shop",
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontFamily: 'Anton',
                        fontSize: 50,
                      ),
                    ),
                  )),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }


Future<void> submit() async{
  if(!_formKey.currentState.validate()){
    return;
  }
  setState(() {
    _isLoading=true;    
  });
  try{

  }catch(error){

  }

  setState(() {
    _isLoading=false;
  });
}

void _switchAuthMode(){
  if(_authMode==AuthMode.login){
    setState(() {
      
      _authMode=AuthMode.SignUp;
    });
    _controller.forward();
  }else{
        setState(() {
      
      _authMode=AuthMode.login;
    });
    _controller.reverse();
  }
}
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val.isEmpty || val.length < 5) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: Duration(microseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator:_authMode == AuthMode.SignUp? (val) {
                          if (val!=_passwordController.text || val.length < 5) {
                            return 'Password do not match!';
                          }
                          return null;
                        }:null,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                if(_isLoading) CircularProgressIndicator(),
                 RaisedButton(
                  child :Text(_authMode==AuthMode.login?'LOGIN':'SIGNUP'),
                  onPressed: submit,
                  shape : RoundedRectangleBorder(
                    borderRadius : BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.headline6.color,

                ),
                FlatButton(
                  onPressed: _switchAuthMode,
                   child: Text('${_authMode==AuthMode.login?'SIGNUP':'LOGIN'} INSTEAD'),
                   padding: EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                   //color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryColor,
                   
                   )
             
             
              ],
            ),
          ),
        ),
      ),
    );
  }
}
