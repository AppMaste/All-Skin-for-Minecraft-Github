// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:all_skin_for_minecraft/src/screen/home%20screen/guide%20screen.dart';
import 'package:all_skin_for_minecraft/src/service/ads.dart';
import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;
import '../../widgets/appbar.dart';
import '../../widgets/size.dart';
import 'favorite screen.dart';

var likeTitleData = [].obs;
var likeIDData = [].obs;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var home = true.obs;
  var like = false.obs;
  var guide = false.obs;

  var trending = true.obs;
  var latest = false.obs;
  var NEW = false.obs;
  var mostUsed = false.obs;

  var height = ScreenSize.fSize_40();
  var width = ScreenSize.horizontalBlockSize! * 22.8;

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Scaffold _buildExitDialog(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: ScreenSize.fSize_275(),
          width: ScreenSize.fSize_275(),
          decoration: BoxDecoration(
            color: Colors.black,
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF9188FB).withOpacity(0.6),
                  const Color(0xFFA23BED).withOpacity(0.6),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(ScreenSize.fSize_15()),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B5AF3).withOpacity(0.7),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GradientText(
                "EXIT",
                style: GoogleFonts.chakraPetch(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: ScreenSize.fSize_25()),
                colors: const [
                  Color(0xFF9188FB),
                  Color(0xFFA23BED),
                ],
                gradientDirection: GradientDirection.ttb,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenSize.fSize_15()),
                child: Text(
                  "Do you really want to Exit?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.chakraPetch(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: ScreenSize.fSize_20()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: ScreenSize.horizontalBlockSize! * 11,
                      width: ScreenSize.horizontalBlockSize! * 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(imageUtilController.noImage),
                            fit: BoxFit.cover),
                        // color: const Color(0xFFD8FD91),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            ScreenSize.fSize_100(),
                          ),
                        ),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: GoogleFonts.chakraPetch(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: ScreenSize.fSize_17()),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => SystemNavigator.pop(),
                    child: Container(
                      height: ScreenSize.horizontalBlockSize! * 11,
                      width: ScreenSize.horizontalBlockSize! * 25,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colorUtilsController.exitAlertBoxColor,
                        ),
                        // color: const Color(0xFFD8FD91),
                        borderRadius: BorderRadius.all(Radius.circular(
                          ScreenSize.fSize_100(),
                        )),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: GoogleFonts.chakraPetch(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: ScreenSize.fSize_17()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // data load list
  var dataList = [].obs;
  var latestData = [].obs;
  var newData = [].obs;
  var mostUsedData = [].obs;

  // data search list
  var dataSearchList = [].obs;
  var latestDataSearchList = [].obs;
  var newDataSearchList = [].obs;
  var mostUsedDataSearchList = [].obs;

  int NUMBER = 0;
  var currentPage = 1;

  var error = "".obs;

  var isLoading = false;
  var search = false.obs;

  var scrollController = ScrollController();
  var editingController = TextEditingController().obs;

  _loadMore() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading) {
      currentPage++;
      _fetchData(currentPage);
      _fetchLatestData(currentPage);
      _fetchNewData(currentPage);
      _fetchMostUsedData(currentPage);
    }
  }

  Future _fetchData(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      print("fetchData ${latest.value}");
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=trending&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          dataList.value.addAll(data['skins']);
          dataSearchList.value = dataList.value;
          isLoading = false;
          NUMBER = 1;
          NUMBER == 1 ? _fetchData2(number + 399) : null;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchData2(number) async {
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=trending&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          dataList.value.addAll(data['skins']);
          dataSearchList.value = dataList.value;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchLatestData(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      print("fetchData ${latest.value}");
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          latestData.value.addAll(data['skins']);
          latestDataSearchList.value = latestData.value;
          isLoading = false;
          NUMBER = 1;
          NUMBER == 1 ? _fetchLatestData2(number + 399) : null;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchLatestData2(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      print("fetchData ${latest.value}");
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          latestData.value.addAll(data['skins']);
          latestDataSearchList.value = latestData.value;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchNewData(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      print("fetchData ${latest.value}");
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=views&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          newData.value.addAll(data['skins']);
          newDataSearchList.value = newData.value;
          isLoading = false;
          NUMBER = 1;
          NUMBER == 1 ? _fetchNewData2(number + 399) : null;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchNewData2(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      print("fetchData ${latest.value}");
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=views&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          newData.value.addAll(data['skins']);
          newDataSearchList.value = newData.value;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
        log("errorrrrrr ${e.toString()}");
      });
    }
  }

  Future _fetchMostUsedData(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=download&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          mostUsedData.value.addAll(data['skins']);
          mostUsedDataSearchList.value = mostUsedData.value;
          isLoading = false;
          NUMBER = 1;
          NUMBER == 1 ? _fetchMostUsedData2(number + 399) : null;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
      });
    }
  }

  Future _fetchMostUsedData2(number) async {
    print("fetchData Callback");
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=download&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          mostUsedData.value.addAll(data['skins']);
          mostUsedDataSearchList.value = mostUsedData.value;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error.value = e.toString();
      });
    }
  }

  saveLikeData(var id, var title) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("title", [title]);
    pref.setStringList("id", [id]);
  }

  showLikeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    likeTitleData.value.addAll(pref.getStringList("title")!);
    likeIDData.value.addAll(pref.getStringList("id")!);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
    _fetchData(currentPage);
    showLikeData();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void dataSearchResults(String query) {
    // _fetchData(currentPage);
    setState(() {
      dataSearchList.value = dataList.value
          .where((item) => item['title'].contains(query))
          .toList();
    });
  }

  void latestSearchResults(String query) {
    // _fetchData(currentPage);
    setState(() {
      latestDataSearchList.value = latestData.value
          .where((item) => item['title'].contains(query))
          .toList();
    });
  }

  void newSearchResults(String query) {
    // _fetchData(currentPage);
    setState(() {
      newDataSearchList.value =
          newData.value.where((item) => item['title'].contains(query)).toList();
    });
  }

  void mostUsedSearchResults(String query) {
    // _fetchData(currentPage);
    setState(() {
      mostUsedDataSearchList.value = mostUsedData.value
          .where((item) => item['title'].contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.7;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        drawerEnableOpenDragGesture: false,
        drawer: appBarController.drawer(
          context,
          () {
            Get.back();
            _onWillPop(context);
          },
          () {
            Get.back();
            setState(() {
              home.value = true;
              like.value = false;
              guide.value = false;
            });
          },
          () {
            Get.back();
            setState(() {
              like.value = true;
              home.value = false;
              guide.value = false;
            });
          },
          () {
            Get.back();
            setState(() {
              guide.value = true;
              like.value = false;
              home.value = false;
            });
          },
        ),
        body: Obx(
          () => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                guide.value == true
                    ? appBarController.appbar2()
                    : like.value == true
                        ? appBarController.appbar3()
                        : search.value
                            ? Container(
                                height: ScreenSize.fSize_100(),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colorUtilsController.appBarColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenSize.fSize_10(),
                                      left: ScreenSize.fSize_15()),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ScreenSize.horizontalBlockSize! *
                                            65,
                                        height: ScreenSize.fSize_50(),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                editingController.value.clear();
                                                _fetchData(currentPage);
                                                search.value = false;
                                              },
                                              child: Image.asset(
                                                imageUtilController
                                                    .leftArrowImage,
                                                scale: 2.0,
                                              ),
                                            ),
                                            SizedBox(
                                                width: ScreenSize.fSize_10()),
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    editingController.value,
                                                onFieldSubmitted: (value) {
                                                  dataSearchResults(value);
                                                  latestSearchResults(value);
                                                  newSearchResults(value);
                                                  mostUsedSearchResults(value);
                                                },
                                                style: GoogleFonts.chakraPetch(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenSize.fSize_20(),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Search here",
                                                  hintStyle:
                                                      GoogleFonts.chakraPetch(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenSize.fSize_20(),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenSize.fSize_20()),
                                        child: GestureDetector(
                                          onTap: () {
                                            // search.value = !search.value;
                                          },
                                          child: Image.asset(
                                            imageUtilController.searchImage,
                                            scale: 2.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height: ScreenSize.fSize_100(),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colorUtilsController.appBarColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenSize.fSize_10()),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ScreenSize.fSize_150(),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenSize.fSize_20(),
                                                  right: ScreenSize.fSize_20()),
                                              child:
                                                  Builder(builder: (context) {
                                                return GestureDetector(
                                                  onTap: () =>
                                                      Scaffold.of(context)
                                                          .openDrawer(),
                                                  child: Image.asset(
                                                    imageUtilController
                                                        .drawerIcon,
                                                    scale: 2.0,
                                                  ),
                                                );
                                              }),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenSize.fSize_20()),
                                              child: Text(
                                                "ALL SKIN",
                                                style: GoogleFonts.chakraPetch(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenSize.fSize_20()),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenSize.fSize_20()),
                                        child: GestureDetector(
                                          onTap: () {
                                            search.value = true;
                                          },
                                          child: Image.asset(
                                            imageUtilController.searchImage,
                                            scale: 2.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                // appBarController.appbar(context,likeTitleData.value,dataList.value),
                // SizedBox(height: ScreenSize.fSize_15()),
                home.value == true
                    ? Obx(
                        () => Column(
                          children: [
                            minecraftBannerAD.getBanner("/HomeScreen"),
                            SizedBox(height: ScreenSize.fSize_15()),
                            Container(
                              height: height,
                              width: ScreenSize.horizontalBlockSize! * 92,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  gradient: LinearGradient(
                                    colors: colorUtilsController.appBarColor,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      ScreenSize.fSize_10()),
                                  border: GradientBoxBorder(
                                      gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor))),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      scrollController.position
                                          .restoreOffset(0.0);
                                      trending.value = true;
                                      latest.value = false;
                                      NEW.value = false;
                                      mostUsed.value = false;
                                    },
                                    child: Container(
                                      height: height,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenSize.fSize_8()),
                                        color: trending.value == true
                                            ? Colors.red
                                            : Colors.transparent,
                                        gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Trending",
                                          style: GoogleFonts.chakraPetch(
                                              color: trending.value == true
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _fetchLatestData(currentPage);
                                      scrollController.position
                                          .restoreOffset(0.0);
                                      // log("jsonDATA ${dataList.value}");
                                      trending.value = false;
                                      latest.value = true;
                                      NEW.value = false;
                                      mostUsed.value = false;
                                    },
                                    child: Container(
                                      height: height,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenSize.fSize_8()),
                                        color: latest.value == true
                                            ? Colors.red
                                            : Colors.transparent,
                                        gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Latest",
                                          style: GoogleFonts.chakraPetch(
                                              color: latest.value == true
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      scrollController.position
                                          .restoreOffset(0.0);
                                      _fetchNewData(currentPage);
                                      trending.value = false;
                                      latest.value = false;
                                      NEW.value = true;
                                      mostUsed.value = false;
                                    },
                                    child: Container(
                                      height: height,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenSize.fSize_8()),
                                        color: NEW.value == true
                                            ? Colors.red
                                            : Colors.transparent,
                                        gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "New",
                                          style: GoogleFonts.chakraPetch(
                                              color: NEW.value == true
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _fetchMostUsedData(currentPage);
                                      scrollController.position
                                          .restoreOffset(0.0);
                                      trending.value = false;
                                      latest.value = false;
                                      NEW.value = false;
                                      mostUsed.value = true;
                                    },
                                    child: Container(
                                      height: height,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenSize.fSize_8()),
                                        color: mostUsed.value == true
                                            ? Colors.red
                                            : Colors.transparent,
                                        gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Most Used",
                                          style: GoogleFonts.chakraPetch(
                                              color: mostUsed.value == true
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: ScreenSize.horizontalBlockSize! * 138,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: latest.value == true
                                    ? GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio:
                                              (itemWidth / itemHeight),
                                          // childAspectRatio: 20 / 10,
                                          mainAxisSpacing:
                                              ScreenSize.fSize_15(),
                                          crossAxisSpacing:
                                              ScreenSize.fSize_10(),
                                        ),
                                        controller: scrollController,
                                        itemCount:
                                            latestDataSearchList.value.length +
                                                (isLoading ? 1 : 0),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // log('$dataList');
                                          if (index ==
                                              latestDataSearchList
                                                  .value.length) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            return GestureDetector(
                                              onTap: () {
                                                adController.adButton(
                                                  context,
                                                  "/SkinDetailsScreen",
                                                  "/HomeScreen",
                                                  [
                                                    latestDataSearchList
                                                        .value[index]['title'],
                                                    "http://owlsup.ru/main_catalog/skins/${latestDataSearchList.value[index]['id']}/skinIMG.png",
                                                    "http://owlsup.ru/main_catalog/skins/${latestDataSearchList.value[index]['id']}/skin.png",
                                                    latestDataSearchList
                                                        .value[index]['id'],
                                                  ],
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: colorUtilsController
                                                        .appBarColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenSize.fSize_8()),
                                                  border: GradientBoxBorder(
                                                    gradient: LinearGradient(
                                                        colors: colorUtilsController
                                                            .exitAlertBoxColor),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: ScreenSize
                                                                .fSize_10()),
                                                        child: Image.network(
                                                          "http://owlsup.ru/main_catalog/skins/${latestDataSearchList.value[index]['id']}/skinIMG.png",
                                                          scale: 1.8,
                                                          errorBuilder:
                                                              (context, object,
                                                                  stacktrace) {
                                                            debugPrint(
                                                                "object : ${object.toString()}");
                                                            debugPrint(
                                                                "stacktrace : ${stacktrace.toString()}");
                                                            return Icon(
                                                              Icons.error,
                                                              size: ScreenSize
                                                                  .fSize_30(),
                                                              color: Colors.red,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Container(
                                                        height: ScreenSize
                                                            .fSize_34(),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: colorUtilsController
                                                                .gridviewContainerColor,
                                                          ),
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      ScreenSize
                                                                              .horizontalBlockSize! *
                                                                          2),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      ScreenSize
                                                                              .horizontalBlockSize! *
                                                                          2)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            latestDataSearchList
                                                                    .value[
                                                                index]['title'],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .chakraPetch(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        ScreenSize
                                                                            .fSize_14()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Container(
                                                          height: ScreenSize
                                                              .fSize_25(),
                                                          width: ScreenSize
                                                              .fSize_25(),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient:
                                                                LinearGradient(
                                                              colors: colorUtilsController
                                                                  .gridviewContainerColor,
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                            ),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (likeIDData.value.contains(
                                                                  latestDataSearchList
                                                                              .value[
                                                                          index]
                                                                      ['id'])) {
                                                                // likeIDData
                                                                //     .removeAt(
                                                                //         index);
                                                                // likeTitleData
                                                                //     .removeAt(
                                                                //         index);
                                                              } else {
                                                                likeTitleData
                                                                    .value
                                                                    .addAll([
                                                                  latestDataSearchList
                                                                              .value[
                                                                          index]
                                                                      ['title']
                                                                ]);
                                                                likeIDData
                                                                    .addAll([
                                                                  latestDataSearchList
                                                                          .value[
                                                                      index]['id']
                                                                ]);
                                                                // pref.setStringList("like", [likeTitleData.string]);
                                                              }
                                                              saveLikeData(latestDataSearchList
                                                                  .value[
                                                              index]['id'],latestDataSearchList
                                                                  .value[
                                                              index]['title']);
                                                              likeTitleData
                                                                  .refresh();
                                                              likeIDData
                                                                  .refresh();
                                                            },
                                                            child: Icon(
                                                              (likeTitleData
                                                                      .value
                                                                      .contains(
                                                                          latestDataSearchList.value[index][
                                                                              'title']))
                                                                  ? Icons
                                                                      .favorite_rounded
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: ScreenSize
                                                                  .fSize_20(),
                                                              color:
                                                                  colorUtilsController
                                                                      .likeColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : NEW.value == true
                                        ? GridView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio:
                                                  (itemWidth / itemHeight),
                                              // childAspectRatio: 20 / 10,
                                              mainAxisSpacing:
                                                  ScreenSize.fSize_15(),
                                              crossAxisSpacing:
                                                  ScreenSize.fSize_10(),
                                            ),
                                            controller: scrollController,
                                            itemCount:
                                                newDataSearchList.value.length +
                                                    (isLoading ? 1 : 0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // log('$dataList');
                                              if (index ==
                                                  newDataSearchList
                                                      .value.length) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return GestureDetector(
                                                  onTap: () {
                                                    adController.adButton(
                                                      context,
                                                      "/SkinDetailsScreen",
                                                      "/HomeScreen",
                                                      [
                                                        newDataSearchList
                                                                .value[index]
                                                            ['title'],
                                                        "http://owlsup.ru/main_catalog/skins/${newDataSearchList.value[index]['id']}/skinIMG.png",
                                                        "http://owlsup.ru/main_catalog/skins/${newDataSearchList.value[index]['id']}/skin.png",
                                                        newDataSearchList
                                                            .value[index]['id'],
                                                      ],
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors:
                                                            colorUtilsController
                                                                .appBarColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenSize
                                                                  .fSize_8()),
                                                      border: GradientBoxBorder(
                                                        gradient: LinearGradient(
                                                            colors: colorUtilsController
                                                                .exitAlertBoxColor),
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: ScreenSize
                                                                    .fSize_10()),
                                                            child:
                                                                Image.network(
                                                              "http://owlsup.ru/main_catalog/skins/${newDataSearchList[index]['id']}/skinIMG.png",
                                                              scale: 1.8,
                                                              errorBuilder:
                                                                  (context,
                                                                      object,
                                                                      stacktrace) {
                                                                debugPrint(
                                                                    "object : ${object.toString()}");
                                                                debugPrint(
                                                                    "stacktrace : ${stacktrace.toString()}");
                                                                return Icon(
                                                                  Icons.error,
                                                                  size: ScreenSize
                                                                      .fSize_30(),
                                                                  color: Colors
                                                                      .red,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            height: ScreenSize
                                                                .fSize_34(),
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: colorUtilsController
                                                                    .gridviewContainerColor,
                                                              ),
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          ScreenSize.horizontalBlockSize! *
                                                                              2),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          ScreenSize.horizontalBlockSize! *
                                                                              2)),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                newDataSearchList
                                                                            .value[
                                                                        index]
                                                                    ['title'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.chakraPetch(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        ScreenSize
                                                                            .fSize_14()),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Container(
                                                              height: ScreenSize
                                                                  .fSize_25(),
                                                              width: ScreenSize
                                                                  .fSize_25(),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: colorUtilsController
                                                                      .gridviewContainerColor,
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  if (likeIDData
                                                                      .value
                                                                      .contains(
                                                                          newDataSearchList.value[index]
                                                                              [
                                                                              'id'])) {
                                                                  } else {
                                                                    likeTitleData
                                                                        .value
                                                                        .addAll([
                                                                      newDataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'title']
                                                                    ]);
                                                                    likeIDData
                                                                        .addAll([
                                                                      newDataSearchList
                                                                              .value[index]
                                                                          ['id']
                                                                    ]);
                                                                    }
                                                                  saveLikeData(
                                                                      newDataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'id'],
                                                                      newDataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'title']);
                                                                  likeTitleData
                                                                      .refresh();
                                                                  likeIDData
                                                                      .refresh();
                                                                },
                                                                child: Icon(
                                                                  (likeTitleData
                                                                          .value
                                                                          .contains(newDataSearchList.value[index]
                                                                              [
                                                                              'title']))
                                                                      ? Icons
                                                                          .favorite_rounded
                                                                      : Icons
                                                                          .favorite_border,
                                                                  size: ScreenSize
                                                                      .fSize_20(),
                                                                  color: colorUtilsController
                                                                      .likeColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : GridView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio:
                                                  (itemWidth / itemHeight),
                                              // childAspectRatio: 20 / 10,
                                              mainAxisSpacing:
                                                  ScreenSize.fSize_15(),
                                              crossAxisSpacing:
                                                  ScreenSize.fSize_10(),
                                            ),
                                            controller: scrollController,
                                            itemCount:
                                                dataSearchList.value.length +
                                                    (isLoading ? 1 : 0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index ==
                                                  dataSearchList.value.length) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return GestureDetector(
                                                  onTap: () {
                                                    adController.adButton(
                                                      context,
                                                      "/SkinDetailsScreen",
                                                      "/HomeScreen",
                                                      [
                                                        dataSearchList
                                                                .value[index]
                                                            ['title'],
                                                        "http://owlsup.ru/main_catalog/skins/${dataSearchList.value[index]['id']}/skinIMG.png",
                                                        "http://owlsup.ru/main_catalog/skins/${dataSearchList.value[index]['id']}/skin.png",
                                                        dataSearchList
                                                            .value[index]['id'],
                                                      ],
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors:
                                                            colorUtilsController
                                                                .appBarColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenSize
                                                                  .fSize_8()),
                                                      border: GradientBoxBorder(
                                                        gradient: LinearGradient(
                                                            colors: colorUtilsController
                                                                .exitAlertBoxColor),
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: ScreenSize
                                                                    .fSize_10()),
                                                            child:
                                                                Image.network(
                                                              "http://owlsup.ru/main_catalog/skins/${dataSearchList[index]['id']}/skinIMG.png",
                                                              scale: 1.8,
                                                              errorBuilder:
                                                                  (context,
                                                                      object,
                                                                      stacktrace) {
                                                                debugPrint(
                                                                    "object : ${object.toString()}");
                                                                debugPrint(
                                                                    "stacktrace : ${stacktrace.toString()}");
                                                                return Icon(
                                                                  Icons.error,
                                                                  size: ScreenSize
                                                                      .fSize_30(),
                                                                  color: Colors
                                                                      .red,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            height: ScreenSize
                                                                .fSize_34(),
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: colorUtilsController
                                                                    .gridviewContainerColor,
                                                              ),
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          ScreenSize.horizontalBlockSize! *
                                                                              2),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          ScreenSize.horizontalBlockSize! *
                                                                              2)),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                dataSearchList
                                                                            .value[
                                                                        index]
                                                                    ['title'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.chakraPetch(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        ScreenSize
                                                                            .fSize_14()),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Container(
                                                              height: ScreenSize
                                                                  .fSize_25(),
                                                              width: ScreenSize
                                                                  .fSize_25(),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: colorUtilsController
                                                                      .gridviewContainerColor,
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  if (likeIDData
                                                                      .value
                                                                      .contains(
                                                                          dataSearchList.value[index]
                                                                              [
                                                                              'id'])) {
                                                                  } else {
                                                                    likeTitleData
                                                                        .value
                                                                        .addAll([
                                                                      dataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'title']
                                                                    ]);
                                                                    likeIDData
                                                                        .addAll([
                                                                      dataSearchList
                                                                              .value[index]
                                                                          ['id']
                                                                    ]);
                                                                  }
                                                                  saveLikeData(
                                                                      dataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'id'],
                                                                      dataSearchList
                                                                              .value[index]
                                                                          [
                                                                          'title']);
                                                                  likeTitleData
                                                                      .refresh();
                                                                  likeIDData
                                                                      .refresh();
                                                                },
                                                                child: Obx(
                                                                  () => Icon(
                                                                    (likeTitleData
                                                                            .value
                                                                            .contains(dataSearchList.value[index][
                                                                                'title']))
                                                                        ? Icons
                                                                            .favorite_rounded
                                                                        : Icons
                                                                            .favorite_border,
                                                                    size: ScreenSize
                                                                        .fSize_20(),
                                                                    color: colorUtilsController
                                                                        .likeColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : like.value == true
                        ? FavoriteScreen().favorite(context)
                        : GuideScreen().guide(context, "/HomeScreen"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: ScreenSize.fSize_90(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorUtilsController.appBarColor,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      home.value = true;
                      like.value = false;
                      guide.value = false;
                    },
                    child: Image.asset(
                      home.value == true
                          ? imageUtilController.homeImage
                          : imageUtilController.homeImage1,
                      scale: home.value == true ? 1.5 : 1.7,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      home.value = false;
                      like.value = true;
                      guide.value = false;
                    },
                    child: Image.asset(
                      like.value == true
                          ? imageUtilController.likeImage1
                          : imageUtilController.likeImage,
                      scale: like.value == true ? 1.5 : 1.7,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      home.value = false;
                      like.value = false;
                      guide.value = true;
                    },
                    child: Image.asset(
                      guide.value == true
                          ? imageUtilController.guideImage1
                          : imageUtilController.guideImage,
                      scale: guide.value == true ? 1.5 : 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
