// // ignore_for_file: invalid_use_of_protected_member
//
// import 'dart:convert';
//
// import 'package:all_skin_for_minecraft/src/utilities/color.dart';
// import 'package:all_skin_for_minecraft/src/widgets/size.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:http/http.dart' as http;
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchUser();
//   }
//
//   var users = [].obs;
//
//   fetchUser() async {
//     print("fetchUser called");
//     var uri =
//         "http://owlsup.ru/posts?category=skins&page=1&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2";
//     final url = Uri.parse(uri);
//     final response = await http.get(url);
//     final body = response.body;
//     final json = jsonDecode(body);
//     // setState(() {
//     users.value = json['skins'];
//     print("fetchUser complete $users");
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenSize.sizerInit(context);
//     var size = MediaQuery.of(context).size;
//     final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//     final double itemWidth = size.width / 1.7;
//     return Scaffold(
//       appBar: AppBar(),
//       /* body: Builder(
//         builder: (context) {
//           if (_posts.isEmpty) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return ListView.builder(
//             itemBuilder: (BuildContext context, int index) {
//               if (index == _posts.length) {
//                 return ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(),
//                     ],
//                   ),
//                 );
//               } else {
//                 final _post = _posts[index];
//
//                 return ListTile(
//                   title: Text(
//                     _post['title'],
//                   ),
//                   subtitle: Text(
//                     _post['body'],
//                   ),
//                 );
//               }
//             },
//             itemCount: _posts.length + 1,
//           );
//         },
//       ),*/
//       body: Builder(
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: users.value.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         childAspectRatio: (itemWidth / itemHeight),
//                         // childAspectRatio: 20 / 10,
//                         mainAxisSpacing: ScreenSize.fSize_15(),
//                         crossAxisSpacing: ScreenSize.fSize_10(),
//                       ),
//                       itemCount: users.value.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             // Get.to(
//                             //       () =>
//                             //       SkinDetailsScreen(),
//                             //   arguments: [
//                             //     users[index]['title'],
//                             //     "http://owlsup.ru/main_catalog/skins/${users[index]['id']}/skinIMG.png",
//                             //     "http://owlsup.ru/main_catalog/skins/${users[index]['id']}/skin.png"
//                             //   ],
//                             // );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: colorUtilsController.appBarColor,
//                               ),
//                               borderRadius:
//                                   BorderRadius.circular(ScreenSize.fSize_8()),
//                               border: GradientBoxBorder(
//                                 gradient: LinearGradient(
//                                     colors: colorUtilsController.exitAlertBoxColor),
//                               ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Center(
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         bottom: ScreenSize.fSize_10()),
//                                     child: Image.network(
//                                       "http://owlsup.ru/main_catalog/skins/${users[index]['id']}/skinIMG.png",
//                                       scale: 1.8,
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomCenter,
//                                   child: Container(
//                                     height: ScreenSize.fSize_34(),
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: colorUtilsController
//                                             .gridviewContainerColor,
//                                       ),
//                                       borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(
//                                               ScreenSize.horizontalBlockSize! * 2),
//                                           bottomRight: Radius.circular(
//                                               ScreenSize.horizontalBlockSize! * 2)),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         users[index]['title'],
//                                         style: GoogleFonts.chakraPetch(
//                                             color: Colors.white,
//                                             fontSize: ScreenSize.fSize_14()),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Align(
//                                     alignment: Alignment.topRight,
//                                     child: Container(
//                                       height: ScreenSize.fSize_25(),
//                                       width: ScreenSize.fSize_25(),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         gradient: LinearGradient(
//                                           colors: colorUtilsController
//                                               .gridviewContainerColor,
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                         ),
//                                       ),
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: Icon(
//                                           Icons.favorite_rounded,
//                                           size: ScreenSize.fSize_20(),
//                                           color: colorUtilsController.likeColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             );
//         }
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:all_skin_for_minecraft/demo%202.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  List _dataList = [];
  var _currentPage = 1;
  bool _isLoading = false;
  String? _error;

  int BOOL = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _fetchData(number) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          // data.forEach((key, value) {
          // });
          _dataList.addAll(data['skins']);
          // dataList = data['skins'];
          _isLoading = false;
          BOOL++;
          BOOL == 1 ? _fetchData2(number + 399) : null;
          print("objecttttttttttt $BOOL");
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchData2(number) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          // data.forEach((key, value) {
          // });
          _dataList.addAll(data['skins']);
          // dataList = data['skins'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _currentPage++;
      _fetchData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.sizerInit(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.7;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // dummy();
            Get.to(() => const HomePage());
          });
        },
      ),
      appBar: AppBar(
        title: const Text(
            'Infinite Scrolling Example with Loading and Error States'),
      ),
      body: _error != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Error: $_error')),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio:
                  (itemWidth / itemHeight),
                  // childAspectRatio: 20 / 10,
                  mainAxisSpacing:
                  ScreenSize.fSize_15(),
                  crossAxisSpacing:
                  ScreenSize.fSize_10(),
                ),
                controller: _scrollController,
                itemCount:
                    // dataList.length == 5
                    //     ? squares.length
                    //     :
                    _dataList.length + (_isLoading ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  // log('$dataList');
                  if (index == _dataList.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListTile(
                      leading: Image.network(
                        "http://owlsup.ru/main_catalog/skins/${_dataList[index]['id']}/skinIMG.png",
                      ),
                      subtitle: Text(
                        "${_dataList[index]['title']}",
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
