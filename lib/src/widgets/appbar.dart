import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/color.dart';
import '../utilities/image.dart';

AppBarController appBarController = Get.put(AppBarController());

class AppBarController extends GetxController   {
  appbar() {
    return  Container(
      height: ScreenSize.fSize_100(),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorUtilsController.appBarColor,
        ),
      ),
      child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () =>
                            Scaffold.of(context).openDrawer(),
                        child: Image.asset(
                          imageUtilController.drawerIcon,
                          scale: 2.0,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: ScreenSize.fSize_20()),
                    child: Text(
                      "ALL SKIN",
                      style: GoogleFonts.chakraPetch(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: ScreenSize.fSize_20()),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
              child: Image.asset(
                imageUtilController.searchImage,
                scale: 2.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}