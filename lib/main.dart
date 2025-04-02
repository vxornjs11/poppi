import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poppi/model/store.dart';

//오준석 연습
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage> {
  // final stores = List<Store>;
  final List<Store> stores = [];

  Future<void> fetch() async {
    var url =
        "https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json";
    // var response = await http.get(url as Uri);
    var response = await http.get(Uri.parse(url));

    final jsonResult = jsonDecode(response.body);
    final jsonStores = jsonResult['stores'];
    stores.clear();

    jsonStores.forEach((e) {
      stores.add(Store.fromJson(e));
      // print(stores);
    });

    print(stores.length);
    // print(stores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("마스트재고 있는 곳 : 0곳")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("눌럿음");
            await fetch();
          },
          child: Text("TEXT"),
        ),
      ),
    );
  }
}
