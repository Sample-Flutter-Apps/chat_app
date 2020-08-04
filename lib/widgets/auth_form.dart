import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submitForm;
  final bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  File _pickedImage;
  
  void _pickImage(File pickedImageFile) {
    _pickedImage = pickedImageFile;
  }

  void _trySubmit() {
    //Run validator for all the fields
    final isValid = _formKey.currentState.validate();

    //To remove focus from keyboard
    FocusScope.of(context).unfocus();

    if(_pickedImage == null && !_isLogin){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }

    if (isValid) {
      //Runs save on all the fields
      _formKey.currentState.save();

      widget.submitForm(_email, _password, _username, _isLogin, context,_pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(labelText: 'Enter email address'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter email';
                      } else if (!value.contains('@')) {
                        return 'Enter valid email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value.trim();
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Enter username'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter username';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _username = value.trim();
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Enter password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter password';
                      } else if (value.length <= 4) {
                        return 'Password must contains atleast 5 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _password = value.trim();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: () {
                        _trySubmit();
                      },
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'Already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
