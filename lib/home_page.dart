import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*
   Metodo para retornar o login futuro do usuario
   static Future<bool> login(String user, String password) async {
    var url =
        Uri.parse('https://www.macoratti.net.br/catalogo/api/contas/login');

      //definindo header com o tipo application/json
    var header = {"Content-Type": "application/json"};

      //definindo os parametros do usuario
    Map params = {"username": user, "senha": password, "email": user};

      //pegando o corpo do json
    var _body = json.encode(params);
    print("json enviado : $_body");

    //colocando a url header e o metodo _body como respsta da httpo
    var response = await http.post(url, headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map mapResponse = json.decode(response.body);
    //pegando parametros dentro da api
    String mensagem = mapResponse["message"];
    String token = mapResponse["token"];

    print("message $mensagem");
    print("token $token");

    return true;
  }
  //na pagina de login
    var response = await LoginApi.login(login,senha);
    if(response){
      navigator.push(context, MaterialPageRoute(UserList(),),),
    }
  */
//Metodo para pegar um usuario na lista
  Future<List> pegarUsuarios() async {
    var url = Uri.parse('https://minhasapis.com.br/pessoa');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      //utf8 quebra alguns erros de caracteres q possam ter na api como o caso
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar dados do Servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuário"),
      ),
      body: FutureBuilder<List>(
        future: pegarUsuarios(),
        //snapshot é o retorno dos dados que nossa funçao pegarUsuarios faz
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carrega Usuarioos"),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        NetworkImage(snapshot.data![index]['foto']),
                  ),
                  title: Text(
                      "${snapshot.data![index]['nome']} ${snapshot.data![index]['sobrenome']}"),
                  subtitle: Text(snapshot.data![index]['profissao']),
                  trailing: Text(snapshot.data![index]['cidade']),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
