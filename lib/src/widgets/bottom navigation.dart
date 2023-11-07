import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  var height = ScreenSize.fSize_45();
  var width = ScreenSize.fSize_82();

  container() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fSize_15(),
                vertical: ScreenSize.fSize_20()),
            child: Row(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: Colors.red,
                ),
                Container(
                  height: height,
                  width: width,
                  color: Colors.red,
                ),
                Container(
                  height: height,
                  width: width,
                  color: Colors.red,
                ),
                Container(
                  height: height,
                  width: width,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
