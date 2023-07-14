import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int total = 0;
  var dataJson;

  void _getDataFromStrapi() async {
    var response =
        await http.get(Uri.parse("http://localhost:1337/api/mahasiswas"));
    dataJson = await jsonDecode(response.body);
    print(dataJson["meta"]["pagination"]["total"]);
    setState(() {
      total = dataJson["meta"]["pagination"]["total"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: total,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text(dataJson["data"][index]["attributes"]["nama_mahasiswa"]),
              leading: Icon(Icons.add_home),
              trailing: IconButton(
                  onPressed: () async {
                    var id = dataJson["data"][index]["id"];
                    var response = await http.delete(Uri.parse(
                        "http://localhost:1337/api/mahasiswas/$id"));
                    _getDataFromStrapi();
                  },
                  icon: Icon(Icons.delete)),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDataFromStrapi,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}