import 'package:flutter/material.dart';

class Dados extends StatelessWidget {
  final List<String> conteudo;

  //Recebe os dados da tela anterior (origem) ou local onde a classe foi instanciada
  Dados({Key key, @required this.conteudo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(conteudo[0]),
            Text(conteudo[1]),
            // MaterialButton(
            //   child: Text('Voltar'),
            //   onPressed: () => Navigator.pop(context),
            // )
          ],
        ),
      ),
    );
  }
}
