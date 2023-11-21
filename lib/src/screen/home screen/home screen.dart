// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:all_skin_for_minecraft/src/model.dart';
import 'package:all_skin_for_minecraft/src/screen/home%20screen/guide%20screen.dart';
import 'package:all_skin_for_minecraft/src/screen/home%20screen/skin%20details/skin%20details.dart';
import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/bottom%20navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;
import '../../widgets/appbar.dart';
import '../../widgets/data.dart';
import '../../widgets/size.dart';
import 'favorite screen.dart';

var likeAddList = [].obs;
var users = [].obs;

var dataList = [].obs;
var isLoading = false.obs;
var currentPage = 1.obs;
var scrollController = ScrollController().obs;
var error = "".obs;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  var image = [].obs;
  int NUMBER = 0;
  var dataList = [];
  var isLoading = false;
  var currentPage = 1;
  var scrollController = ScrollController();
  var error = "".obs;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
    // HomeContainer().fetchUser();
    // fetchUser();
    _fetchData(currentPage);
  }

  void _loadMore() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading) {
      currentPage++;
      _fetchData(currentPage);
    }
  }

  Future _fetchData(number) async {
    setState(() {
      isLoading = true;
      error.value = "";
    });
    try {
      final response = await http.get(Uri.parse(
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          // data.forEach((key, value) {
          // });
          dataList.addAll(data['skins']);
          // dataList = data['skins'];
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
          'http://owlsup.ru/posts?category=skins&page=$number&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          // data.forEach((key, value) {
          // });
          dataList.addAll(data['skins']);
          // dataList = data['skins'];
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
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
            });
          },
          () {
            Get.back();
            setState(() {
              like.value = true;
            });
          },
          () {
            Get.back();
            setState(() {
              guide.value = true;
            });
          },
          // like.value,
          // guide.value,
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                guide.value == true
                    ? appBarController.appbar2()
                    : like.value == true
                        ? appBarController.appbar3()
                        : appBarController.appbar(),
                home.value == true
                    ? Padding(
                      padding:
                          EdgeInsets.only(top: ScreenSize.fSize_50()),
                      child: Container(
                        height: ScreenSize.horizontalBlockSize! * 140,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
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
                            controller: scrollController,
                            itemCount:
                            // dataList.length == 5
                            //     ? squares.length
                            //     :
                            dataList.length + (isLoading ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              // log('$dataList');
                              if (index == dataList.length) {
                                return const Center(child: CircularProgressIndicator());
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                          () =>
                                          SkinDetailsScreen(),
                                      arguments: [
                                        dataList[index]['title'],
                                        "http://owlsup.ru/main_catalog/skins/${dataList[index]['id']}/skinIMG.png",
                                        "http://owlsup.ru/main_catalog/skins/${dataList[index]['id']}/skin.png"
                                      ],
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient:
                                      LinearGradient(
                                        colors:
                                        colorUtilsController
                                            .appBarColor,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(
                                          ScreenSize
                                              .fSize_8()),
                                      border:
                                      GradientBoxBorder(
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
                                              "http://owlsup.ru/main_catalog/skins/${dataList[index]['id']}/skinIMG.png",
                                              scale: 1.8,
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
                                                  bottomLeft:
                                                  Radius.circular(
                                                      ScreenSize.horizontalBlockSize! *
                                                          2),
                                                  bottomRight:
                                                  Radius.circular(ScreenSize.horizontalBlockSize! *
                                                      2)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                dataList[
                                                index]
                                                ['title'],
                                                textAlign: TextAlign.center,
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
                                            alignment:
                                            Alignment
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
                                                onTap: () {},
                                                child: Icon(
                                                  Icons
                                                      .favorite_rounded,
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
                          ),
                        ),
                      ),
                    )
                    : like.value == true
                        ? FavoriteScreen().favorite()
                        : GuideScreen().guide(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar:  Container(
          height: ScreenSize.fSize_90(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorUtilsController.appBarColor,
            ),
          ),
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
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
                      // Get.to(() => MyHomePage());
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

/*Padding(
padding: EdgeInsets.symmetric(
horizontal: ScreenSize.fSize_12(),
vertical: ScreenSize.fSize_20()),
child:  Container(
height: height,
width: ScreenSize.horizontalBlockSize! * 92,
decoration: BoxDecoration(
color: Colors.green,
gradient: LinearGradient(
colors:
colorUtilsController.appBarColor,
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
trending.value = true;
latest.value = false;
NEW.value = false;
mostUsed.value = false;
},
child: Container(
height: height,
width: width,
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(
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
color:
trending.value == true
? Colors.white
    : Colors.grey),
),
),
),
),
GestureDetector(
onTap: () {
trending.value = false;
latest.value = true;
NEW.value = false;
mostUsed.value = false;
},
child: Container(
height: height,
width: width,
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(
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
trending.value = false;
latest.value = false;
NEW.value = true;
mostUsed.value = false;
},
child: Container(
height: height,
width: width,
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(
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
trending.value = false;
latest.value = false;
NEW.value = false;
mostUsed.value = true;
},
child: Container(
height: height,
width: width,
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(
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
color:
mostUsed.value == true
? Colors.white
    : Colors.grey),
),
),
),
),
],
),
),
),*/
