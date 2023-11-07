// ignore_for_file: must_be_immutable

import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/bottom%20navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/appbar.dart';
import '../../widgets/size.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var home = true.obs;
  var like = false.obs;
  var guide = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawerEnableOpenDragGesture: false,
      drawer: const Drawer(),
      body: Stack(
        children: [
          Column(
            children: [
              appBarController.appbar(),
              Obx(
                () => home.value == true
                    ? HomeContainer().container()
                    : like.value == true
                        ? const Text(
                            "like",
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            "guide",
                            style: TextStyle(color: Colors.white),
                          ),
              ),
            ],
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
    );
  }
}
