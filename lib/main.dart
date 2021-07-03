import 'package:flutter/material.dart';
import 'dart:convert'; // trabalha com o json
import 'package:http/http.dart' as http; // trabalha com o protocolo HTTP

import 'models/pessoa.dart';
import 'views/dados.dart';
//import 'cadastrar.dart';

// Método principal da aplicação
void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  //  Variáveis do ambiente que receberão os dados da API
  String _id = '';
  String _nome = '';
  String _email = '';
  String _mensagem = '';

  // Documentação da API
  // https://github.com/EdsonMSouza/simple-php-api

  // Endereço da API
  Uri url = Uri.parse('http://emsapi.esy.es/rest/api/search/');

  // Método para requisição da API
  jsonRestApiHttp() async {
    // esse bloco de código envia a requisição ao servidor da API
    http.Response response = await http.post(
      this.url,
      headers: <String, String>{
        "Content-Type": "Application/json; charset=UTF-8",
        "Authorization": "123",
      },
      body: jsonEncode(<String, String>{
        "username": usuarioController.text,
        "password": senhaController.text,
      }),
    );

    // Bloco que recupera a informação do servidor e converte JSON para objeto
    final parsed = json.decode(response.body);
    var pessoa = Pessoa.fromJson(parsed);

    // Vamos mostrar os dados na tela do APP, tratando os erros
    try {
      if (int.parse(pessoa.id) > 0) {
        usuarioController.text = '';
        senhaController.text = '';
        setState(() {
          _id = pessoa.id;
          _nome = pessoa.nome;
          _email = pessoa.email;
          _mensagem = '';

          // envia os dados após recuperar da API (se deu certo)
          _enviarDadosOutraTela(context);
        });
      }
    } catch (e) {
      // se não retornou dados (id, nome, email)
      usuarioController.text = '';
      senhaController.text = '';
      setState(() {
        _id = '';
        _nome = '';
        _email = '';
        _mensagem = pessoa.message;
        print(_mensagem);
      });
    }
  }

  //método para enviar dados para outra tela (view)
  void _enviarDadosOutraTela(BuildContext context) {
    // Variável para armazenar os dados que queremos passar à outra tela
    List conteudo = <String>[_nome, _email];

    //enviar os dados efetivamente, ou seja, abrir a outra tela
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dados(conteudo: conteudo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navegação entre Telas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(100.0, 0, 100.0, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo usuário
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextFormField(
                  controller: usuarioController,
                  decoration: InputDecoration(labelText: "Usuário"),
                ),
              ),

              // Campo senha
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextFormField(
                  controller: senhaController,
                  decoration: InputDecoration(labelText: "Senha"),
                ),
              ),

              // Login
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  height: 50.0,
                  child: RawMaterialButton(
                    fillColor: Colors.blue[100],
                    onPressed: () {
                      jsonRestApiHttp();
                      //_enviarDadosOutraTela(context);
                    },
                    child: Text('Login'),
                  ),
                ),
              ),
              // Mostra a msg de erro da API
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  height: 50.0,
                  child: Text(_mensagem),
                ),
              ),
              // Botão para cadastrar
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  height: 50.0,
                  child: RawMaterialButton(
                    fillColor: Colors.blue[100],
                    onPressed: () {},
                    child: Text(
                      'Cadastrar',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
