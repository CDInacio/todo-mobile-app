import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/helpers/http_Exeption.dart';
//provider
import '../providers/auth.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Map<String, String> _authData = {'email': '', 'password': ''};

  AuthMode _authMode = AuthMode.login;

  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  void _showDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Ocorreu um erro'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_authMode == AuthMode.register) {
        await Provider.of<Auth>(context, listen: false)
            .register(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      String errorMsg = 'Algo deu errado com a altenticação!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'O endereço de e-mail já está sendo usado por outra conta';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMsg = 'O endereço de e-mail é inválido';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'Não foi encontrado um usuário com esse e-mail';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMsg = 'Senha fraca';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMsg = 'Senha inválida';
      }
      _showDialog(errorMsg);
    } catch (error) {
      const errMsg =
          'Não foi possível realizar a autenticação. Por favor, tente novamente mais tarde';
      _showDialog(errMsg);
    }
  }

  void _changeAuthMode() {
    if (_authMode == AuthMode.register) {
      setState(() {
        _authMode = AuthMode.login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.register;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                  child: Text(
                    'Seja Bem-Vindo(a) ao memo,',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                      _authMode == AuthMode.register
                          ? 'Crie sua conta para continuar.'
                          : 'Entre para continuar',
                      style: const TextStyle(fontWeight: (FontWeight.bold))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Senha'),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.length < 5) {
                        return 'A senha precisa ter mais de 5 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                ),
                if (_authMode == AuthMode.register)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirmar senha'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value != _passwordController.text) {
                          return 'Senhas diferentes';
                        }
                        return null;
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange)),
                      onPressed: _submitForm,
                      child: Text(_authMode == AuthMode.register
                          ? 'Cadastrar'
                          : 'Entrar'),
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0)),
                    onPressed: _changeAuthMode,
                    child: Text(_authMode == AuthMode.register
                        ? 'Já tem uma conta? Entre aqui'
                        : ' Não tem uma conta, cadastre-se aqui'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
