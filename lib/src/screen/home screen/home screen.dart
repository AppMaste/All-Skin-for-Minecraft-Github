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
                colors: [
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

  @override
  void initState() {
    super.initState();
    // HomeContainer().fetchUser();
    fetchUser();
  }

  fetchUser() async {
    print("fetchUser called");
    var uri =
        "http://owlsup.ru/posts?category=skins&page=1&lang=en&sort=downloads&order=desc&apiKey=37b51d194a7513e45b56f6524f2d51f2";
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    // setState(() {
    users.value = json['skins'];
    print("fetchUser complete $users");
    print("initState called");
  }

/*  fetchUser2([String? id]) async {
    print("fetchUser called");
    var uri =
        "http://owlsup.ru/main_catalog/skins/$id/skin.png";
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    // setState(() {
    image.value = json['skins'];
    print("fetchUser complete $users");
    // });
  }*/

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
          home.value,
          like.value,
          guide.value,
        ),
        body: Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  guide.value == true
                      ? appBarController.appbar2()
                      : like.value == true
                          ? appBarController.appbar3()
                          : appBarController.appbar(),
                  home.value == true
                      ? HomeContainer().home(context)
                      : like.value == true
                          ? FavoriteScreen().favorite()
                          : GuideScreen().guide(context),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
            // BottomNavigation().homeScreenNavigation(),
          ],
        ),
      ),
    );
  }
}
