// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/data.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../screen/home screen/home screen.dart';
import '../screen/home screen/skin details/skin details.dart';

BottomNavigation bottomNavigationController = Get.put(BottomNavigation());

class BottomNavigation extends GetxController {
  homeScreenNavigation(BuildContext context, var home, var like, var guide) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenSize.fSize_90(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorUtilsController.appBarColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  home = true;
                  like = false;
                  guide = false;
                },
                child: Image.asset(
                  home == true
                      ? imageUtilController.homeImage
                      : imageUtilController.homeImage1,
                  scale: home == true ? 1.5 : 1.7,
                ),
              ),
              GestureDetector(
                onTap: () {
                  home = false;
                  like = true;
                  guide = false;
                },
                child: Image.asset(
                  like == true
                      ? imageUtilController.likeImage1
                      : imageUtilController.likeImage,
                  scale: like == true ? 1.5 : 1.7,
                ),
              ),
              GestureDetector(
                onTap: () {
                  home = false;
                  like = false;
                  guide = true;
                },
                child: Image.asset(
                  guide == true
                      ? imageUtilController.guideImage1
                      : imageUtilController.guideImage,
                  scale: guide == true ? 1.5 : 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContainer {
  var trending = true.obs;
  var latest = false.obs;
  var NEW = false.obs;
  var mostUsed = false.obs;

  var height = ScreenSize.fSize_40();
  var width = ScreenSize.horizontalBlockSize! * 22.8;

  home(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.7;
    return Center(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fSize_12(),
                vertical: ScreenSize.fSize_20()),
            child: Obx(
              () => Container(
                height: height,
                width: ScreenSize.horizontalBlockSize! * 92,
                decoration: BoxDecoration(
                    color: Colors.green,
                    gradient: LinearGradient(
                      colors: colorUtilsController.appBarColor,
                    ),
                    borderRadius: BorderRadius.circular(ScreenSize.fSize_10()),
                    border: GradientBoxBorder(
                        gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor))),
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
                              BorderRadius.circular(ScreenSize.fSize_8()),
                          color: trending.value == true
                              ? Colors.red
                              : Colors.transparent,
                          gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor,
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
                              BorderRadius.circular(ScreenSize.fSize_8()),
                          color: latest.value == true
                              ? Colors.red
                              : Colors.transparent,
                          gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor,
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
                              BorderRadius.circular(ScreenSize.fSize_8()),
                          color: NEW.value == true
                              ? Colors.red
                              : Colors.transparent,
                          gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor,
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
                              BorderRadius.circular(ScreenSize.fSize_8()),
                          color: mostUsed.value == true
                              ? Colors.red
                              : Colors.transparent,
                          gradient: LinearGradient(
                            colors: colorUtilsController.exitAlertBoxColor,
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
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenSize.fSize_50()),
            child: Container(
              height: ScreenSize.horizontalBlockSize! * 140,
              color: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => error.value.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      controller: scrollController.value,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: (itemWidth / itemHeight),
                              // childAspectRatio: 20 / 10,
                              mainAxisSpacing: ScreenSize.fSize_15(),
                              crossAxisSpacing: ScreenSize.fSize_10(),
                            ),
                            itemCount: dataList.value.length +
                                (isLoading.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == dataList.value.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => SkinDetailsScreen(),
                                      arguments: [
                                        users[index]['title'],
                                        "http://owlsup.ru/main_catalog/skins/${users[index]['id']}/skinIMG.png",
                                        "http://owlsup.ru/main_catalog/skins/${users[index]['id']}/skin.png"
                                      ],
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            colorUtilsController.appBarColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
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
                                                bottom: ScreenSize.fSize_10()),
                                            child: Image.network(
                                              "http://owlsup.ru/main_catalog/skins/${dataList.value[index]['id']}/skinIMG.png",
                                              scale: 1.8,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: ScreenSize.fSize_34(),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: colorUtilsController
                                                    .gridviewContainerColor,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      ScreenSize
                                                              .horizontalBlockSize! *
                                                          2),
                                                  bottomRight: Radius.circular(
                                                      ScreenSize
                                                              .horizontalBlockSize! *
                                                          2)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                dataList.value[index]['title'],
                                                style: GoogleFonts.chakraPetch(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenSize.fSize_14()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              height: ScreenSize.fSize_25(),
                                              width: ScreenSize.fSize_25(),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: colorUtilsController
                                                      .gridviewContainerColor,
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.favorite_rounded,
                                                  size: ScreenSize.fSize_20(),
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
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
