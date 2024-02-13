// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';
import '../provider/auth.dart';
import '../models/httpExeption.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    int activeIndex = 0;
    final List<String> _images = [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrrGWyyRdhy6KnlaTLHfQS33vZZX_4So_Scg&usqp=CAU",
      "https://www.zikoko.com/wp-content/uploads/zikoko/2022/01/adidas.png",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaAjttF6RjOtB8t4ouA-6MjdMvAz3VuTuEcA&usqp=CAU",
      "https://inkbotdesign.com/wp-content/uploads/2023/08/best-shoe-brand-logos-converse-star-1024x833.webp",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZacs3q4VGbvIZaH8DptkEB9kA3pGfvtFFCg&usqp=CAU",
      "https://s3.amazonaws.com/cdn.designcrowd.com/blog/40-Famous-Shoe-Logos/Droors-Clothing.png",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1owYUWpHhJtaCeM3BcHh_2EQl4yuD9c-bTg&usqp=CAU",
      "https://www.zikoko.com/wp-content/uploads/zikoko/2022/01/asics.png"
    ];
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Flexible(
        // flex: deviceSize.width > 600 ? 2 : 1,
        child: AuthCard(),
      ),
      // ],
      // ),
      // ),
      // ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

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
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email']!, _authData["password"]!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData["password"]!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. please try again';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool isVisible = false;

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
    // return Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    //   elevation: 8.0,
    // child: Container(
    // height: _authMode == AuthMode.Signup ? 420 : 360,
    // constraints:
    // BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
    // width: deviceSize.width * 1,
    // padding: EdgeInsets.all(16.0),
    // child:
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //We put all our textfield to a form to be controlled and not allow as empty
            child: Form(
              key: _formKey,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: Column(
                  children: [
                    //Username field

                    //Before we show the image, after we copied the image we need to define the location in pubspec.yaml
                    Image.asset(
                      "images/Icon.jpg",
                      width: 300,
                    ),
                    // const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        // controller: username,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },

                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                      ),
                    ),

                    //Password field
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value!.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.lock),
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  //In here we will create a click to show and hide the password a toggle button
                                  setState(() {
                                    //toggle button
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                      ),
                    ),
                    if (_authMode == AuthMode.Signup)
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.deepPurple.withOpacity(.2)),
                        child: TextFormField(
                          // controller: confirmPassword,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,

                          obscureText: !isVisible,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    //In here we will create a click to show and hide the password a toggle button
                                    setState(() {
                                      //toggle button
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                        ),
                      ),

                    const SizedBox(height: 10),
                    //Login button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple),
                      child: _isLoading
                          ? SizedBox(
                              child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white))),
                              height: 200.0,
                              width: 200.0,
                            )
                          : TextButton(
                              onPressed: _submit,
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              )),
                    ),

                    //Sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: _switchAuthMode,
                            //Navigate to sign up
                            // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => const SignUp())
                            // );

                            child: Text(_authMode == AuthMode.Login
                                ? 'SIGN UP'
                                : 'LOGIN'))
                      ],
                    ),

                    // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                    // isLoginTrue
                    //     ? const Text(
                    //         "Username or passowrd is incorrect",
                    //         style: TextStyle(color: Colors.red),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Container(
    //   // decoration: BoxDecoration(color: ),
    //   height: _authMode == AuthMode.Signup ? 520 : 300,
    //   child: Form(
    //     key: _formKey,
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    //           child: TextFormField(
    //             decoration: InputDecoration(labelText: 'E-mail'),
    //             keyboardType: TextInputType.emailAddress,
    //             validator: (value) {
    //               if (value!.isEmpty || !value.contains('@')) {
    //                 return 'Invalid email!';
    //               }
    //               return null;
    //             },
    //             onSaved: (value) {
    //               _authData['email'] = value!;
    //             },
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 5,
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 15),
    //           child: TextFormField(
    //             decoration: InputDecoration(labelText: 'Password'),
    //             obscureText: true,
    //             controller: _passwordController,
    //             validator: (value) {
    //               if (value!.isEmpty || value!.length < 5) {
    //                 return 'Password is too short!';
    //               }
    //             },
    //             onSaved: (value) {
    //               _authData['password'] = value!;
    //             },
    //           ),
    //         ),
    //         if (_authMode == AuthMode.Signup)
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 15),
    //             child: TextFormField(
    //               enabled: _authMode == AuthMode.Signup,
    //               decoration: InputDecoration(labelText: 'Confirm Password'),
    //               obscureText: true,
    //               validator: _authMode == AuthMode.Signup
    //                   ? (value) {
    //                       if (value != _passwordController.text) {
    //                         return 'Passwords do not match!';
    //                       }
    //                     }
    //                   : null,
    //             ),
    //           ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         if (_isLoading)
    //           CircularProgressIndicator()
    //         else
    //           // ElevatedButton(
    //           //   child:
    //           //       Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
    //           //   onPressed: _submit,
    //           //   shape: RoundedRectangleBorder(
    //           //     borderRadius: BorderRadius.circular(30),
    //           //   ),
    //           //   padding:
    //           //       EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
    //           //   color: Theme.of(context).primaryColor,
    //           //   textColor: Theme.of(context).primaryTextTheme.button.color,
    //           // ),
    //           ElevatedButton(
    //             onPressed: _submit,
    //             style: ElevatedButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(30),
    //               ),
    //               padding:
    //                   EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
    //             ),
    //             child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
    //           ),

    //         // TextButton(
    //         //   child: Text(
    //         //       '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
    //         //   onPressed: _switchAuthMode,
    //         //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
    //         //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //         //   textColor: Theme.of(context).primaryColor,
    //         // ),
    //         TextButton(
    //           onPressed: _switchAuthMode,
    //           style: TextButton.styleFrom(
    //             padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
    //             // primary: Theme.of(context).primaryColor,
    //           ),
    //           child: Text(
    //             '${_authMode == AuthMode.Login ? 'SIGN-UP ' : 'LOGIN '} INSTEAD',
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
