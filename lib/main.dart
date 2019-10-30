import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main (){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controlador = TextEditingController();

  List _listaDeTarefas = [];


  @override
  void initState() {
    super.initState();
    _readData().then((data){
      setState(() {
        _listaDeTarefas = json.decode(data);
      });

    });
  }

  void _addTarefa(){
    setState(() {
      Map<String, dynamic> novaTarefa = Map();
      novaTarefa["title"] = _controlador.text;
      _controlador.text = "";
      novaTarefa["Ok"] = false;
      _listaDeTarefas.add(novaTarefa);
      _saveData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body:  Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Row(
              children: <Widget>[
                Expanded(
                  child:TextFormField(
                    controller: _controlador,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ],
            ),

      ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 120),
                padding:  EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: RaisedButton(
                  color: Colors.brown,
                  child: Text("Adicionar"),
                  textColor: Colors.white,
                  onPressed: (){
                    _addTarefa();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: _listaDeTarefasNovas(),
          ),
        ],
      ),
    );
  }

  Widget _listaDeTarefasNovas(){
    return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: _listaDeTarefas.length,
        itemBuilder:(context, index){
          return CheckboxListTile(
            activeColor: Colors.green,
           title: Text(_listaDeTarefas[index]["title"]),
            value: _listaDeTarefas[index]["Ok"],
            secondary: CircleAvatar(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              child:Icon(_listaDeTarefas[index]["Ok"] ? Icons.check : Icons.error) ,),
            onChanged: (c){
             setState(() {
               _listaDeTarefas[index]["Ok"] = c;
               _saveData();
             });
            },
          );
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_listaDeTarefas);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    } catch (e){
      return null;
    }
  }

}
