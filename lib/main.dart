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
  final List<Store> stores2 = [];

  // stores2
  var isLoding = true;

  Future<void> fetch() async {
    setState(() {
      isLoding = true;
    });

    var url =
        "https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json";
    // var response = await http.get(url as Uri);
    var response = await http.get(Uri.parse(url));

    final jsonResult = jsonDecode(response.body);
    final jsonStores = jsonResult['stores'];

    setState(() {
      stores.clear();

      jsonStores.forEach((e) {
        stores.add(Store.fromJson(e));
        // print(stores);
        isLoding = false;
      });
    });

    // print(stores.length);
    // print(stores);
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "마스트재고 있는 곳 : ${stores.where((e) => e.remainStat == "plenty" || e.remainStat == "some" || e.remainStat == "pew").length}곳",
        ),

        actions: [
          // Icon(icon)
          IconButton(
            onPressed: () {
              ///
              fetch();
              // print("object");
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          isLoding
              ? loadingWidget()
              :
              // ListView(
              //   children:
              //       stores
              //           .where((e) => e.remainStat == "empty")
              //           .map(
              //             (e) => ListTile(
              //               title: Text("${e.name}"),
              //               subtitle: Text("${e.addr}"),
              //               trailing: _buildeRemainStatsWidget(e),
              //             ),
              //           )
              //           .toList(),
              // )
              ListView.builder(
                itemCount:
                    stores
                        .where(
                          (e) =>
                              e.remainStat == "plenty" ||
                              e.remainStat == "some" ||
                              e.remainStat == "pew",
                        )
                        .length,
                itemBuilder: (context, index) {
                  // print(object)
                  // stores == stores.where((e) => e.remainStat == "empty");
                  // stores2 == stores.where((e) => e.remainStat == "empty");
                  final doc =
                      stores
                          .where(
                            (e) =>
                                e.remainStat == "plenty" ||
                                e.remainStat == "some" ||
                                e.remainStat == "pew",
                          )
                          .toList()[index];
                  // print(doc.remainStat);

                  //  final do2c = doc.remainStat !="empty";
                  // final data = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text("${doc.name}"),
                    subtitle: Text("${doc.addr}"),
                    trailing: _buildeRemainStatsWidget(doc),
                  );
                },
              ),
    );
  }

  Widget _buildeRemainStatsWidget(Store store) {
    var remainStat = "판매중지";
    var description = "판매중지";
    var color = Colors.black;
    if (store.remainStat == 'plenty') {
      remainStat = "충분";
      description = '100개이상';
      color = Colors.green;
    }
    switch (store.remainStat) {
      case "plenty":
        remainStat = "충분";
        description = '100개이상';
        color = Colors.green;
        break;
      case "some":
        remainStat = "보통";
        description = '30 ~ 100개이상';
        color = Colors.yellow;
        break;
      case "few":
        remainStat = "부족";
        description = '2 ~ 30개이상';
        color = Colors.red;
        break;
      case "empty":
        remainStat = "소진임박";
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
        print("정의되지 않은 상태입니다.");
        break;
      // default
    }
    return Column(
      children: <Widget>[
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(description, style: TextStyle(color: color)),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("데이터 가져오는 중"), CircularProgressIndicator()],
      ),
    );
  }
}
