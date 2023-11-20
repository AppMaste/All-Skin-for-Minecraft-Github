/*
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataLoad extends StatefulWidget {
  const DataLoad({super.key});

  @override
  State<DataLoad> createState() => _DataLoadState();
}

class _DataLoadState extends State<DataLoad> {
  List users = [];
  List users2 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data Load"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            // final id = user['id'];
            log("afjafjafjasfhasfvasfhasf ${"http://owlsup.ru/posts?category=skins&page=${index +1}&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2"}");
            // final email = user['email'];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text("$user"),
              ),
              // title: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     users[index]['id'].toString(),
              //     style: const TextStyle(
              //       color: Colors.white,
              //     ),
              //   ),

              // ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUser,
      ),
    );
  }

  fetchUser() async {
    print("fetchUser called");
    var uri =
        "http://owlsup.ru/posts?category=skins&page=1&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2";
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['skins'];
      print("fetchUser complete");
    });
  }

  fetchUser2() async {
    print("fetchUser called");
    var uri = "http://owlsup.ru/main_catalog/skins/4889/skin.png";
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users2 = json['skins'];
      print("fetchUser complete");
    });
  }
}
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> myDataList = [];

  List users = [];

  List<String> items = List.generate(15, (index) => 'Item $index');
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    fetchUser();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Simulate loading more data.
  void loadMoreData() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        List<String> newItems =
            List.generate(5, (index) => 'Item ${items.length + index}');
        setState(() {
          items.addAll(newItems);
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll and Add More Data in List'),
      ),
     /* body: ListView.builder(
        controller: _scrollController,
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (index < items.length) {
            return ListTile(
              title: Text(items[index]),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),*/
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                myDataList.add("Item ${users.length}");
              });
            },
            child: const Text("Add Item"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myDataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(myDataList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  fetchUser() async {
    print("fetchUser called");
    var uri =
        "http://owlsup.ru/posts?category=skins&page=1&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2";
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['skins'];
      print("fetchUser complete");
    });
  }
}
