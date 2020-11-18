import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page.dart';
import 'bloc/login_bloc.dart';
import 'form_body.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _email = TextEditingController();
  TextEditingController _contrasena = TextEditingController();
  LoginBloc _loginBloc;
  bool _showLoading = false;

  // @override
  // void dispose() {
  //   _loginBloc.close();
  //   super.dispose();
  // }

  void _register(String email, String password) {
    Navigator.of(context).pop();
    _loginBloc.add(RegisterWithEmailEvent(email: email, password: password));
  }

  void _login(String email, String password) {
    Navigator.of(context).pop();
    _loginBloc.add(LoginWithEmailEvent(email: email, password: password));
  }

  void _emailLogIn(bool _) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: MediaQuery.of(context)
              .viewInsets, // mostrar contenido sobre el teclado
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: "Correo",
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: _contrasena,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Contraseña",
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    leading: new Icon(Icons.login),
                    onTap: () {
                      _login(_email.text, _contrasena.text);
                    },
                    title: Text("Login"),
                  ),
                  ListTile(
                    leading: new Icon(Icons.account_box_rounded),
                    onTap: () {
                      _register(_email.text, _contrasena.text);
                    },
                    title: Text("Registro"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _googleLogIn(bool _) {
    // invocar al login de firebase con el bloc
    // recodar configurar pantallad Oauth en google Cloud
    _loginBloc.add(LoginWithGoogleEvent());
  }

  void _facebookLogIn(bool _) {
    // invocar al login de firebase con el bloc
    _loginBloc.add(LoginWithFacebookEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // stack background image
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0884cc),
                Color(0xff04476e),
              ],
            ),
          ),
        ),
        // form content
        SafeArea(
          child: BlocProvider(
            create: (context) {
              _loginBloc = LoginBloc();
              return _loginBloc..add(VerifyLogInEvent());
            },
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginErrorState) {
                  _showLoading = false;
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Text("${state.error}"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          )
                        ],
                      );
                    },
                  );
                } else if (state is LoginLoadingState) {
                  _showLoading = !_showLoading;
                }
              },
              builder: (context, state) {
                if (state is LoginSuccessState) {
                  return HomePage();
                }
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xa0FFffff),
                    ),
                    child: FormBody(
                      onFacebookLoginTap: _facebookLogIn,
                      onGoogleLoginTap: _googleLogIn,
                      onEmailLoginTap: _emailLogIn,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _showLoading ? CircularProgressIndicator() : Container(),
        ),
      ],
    );
  }
}
