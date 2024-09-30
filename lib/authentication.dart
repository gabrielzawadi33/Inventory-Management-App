import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/homeSreen.Dart';
enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/tabs-screen');
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.green[50]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * 3.14159 / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'inventory',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Up Successful!'),
        content: const Text('You have signed up successfully. Please log in.'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _authMode = AuthMode.Login;
              });
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final response;
      if (_authMode == AuthMode.Login) {
        response = await http.post(
          Uri.parse('https://app.ema.co.tz/api/login'),
          body: json.encode({
            'email': _authData['email'],
            'password': _authData['password'],
          }),
          headers: {"Content-Type": "application/json"},
        );
      } 
      else {  
        
        // User wants to sign up
        response = await http.post(
          Uri.parse('https://app.ema.co.tz/api/register'),
          body: json.encode({
            'name': _authData['name'],
            'reference_no': _authData['reference_no'],
            'adress': _authData['adress'],
            'email': _authData['email'],
            'password': _authData['password'],
            'register_as': _authData['register_as'],
            'phone_number': _authData['phone_number'],
            
          }),
          headers: {"Content-Type": "application/json"},
        );
      }

      final responseData = json.decode(response.body);
      print('************${responseData}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_authMode == AuthMode.Login) {

           // Successfully logged in, navigate to the CustomerListScreen
        Navigator.of(context).pushReplacementNamed('/home');

          print('*******OK****${responseData}*');
        } else {
          _showSuccessDialog();
            if (response.statusCode == 200 || response.statusCode == 201) {
    _showSuccessDialog();
    Navigator.of(context).pushReplacementNamed('/customers');
            }
          print('*************************${response.body}*************************************************');
        }
      } else {
        _showErrorDialog('*********************Failed with status code: ${response.body}*****************************');
        print(response.body);
      }
    } 
    catch (error) {
      _showErrorDialog('Error occurred: $error');
      
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 10.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 900 : 800,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 900 : 800),
        width: deviceSize.width * 0.80,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'UserName',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Please enter your Name!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['name'] = value!;
                  },
                ),
                SizedBox(height: 10),
                if(_authMode == AuthMode.Signup)
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Reference Number',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'please enter refference_no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['reference_no'] = value!;
                  },
                ),
                SizedBox(height: 10),
                if (_authMode == AuthMode.Signup)
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['address'] = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                SizedBox(height: 10),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Register As',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['register_as'] = value!;
                  },
                ),
                SizedBox(height: 10),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  initialValue: 'D',
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Namba ya Simu',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your phone number!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['phone_number'] = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'password',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'please enter your password!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                SizedBox(height: 10),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Maneno ya siri hayafanani!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                     
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'}',
                    style: TextStyle(color: Colors.green),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
