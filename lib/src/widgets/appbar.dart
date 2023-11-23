import 'package:all_skin_for_minecraft/src/widgets/bottom%20navigation.dart';
import 'package:all_skin_for_minecraft/src/widgets/drawer.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/color.dart';
import '../utilities/image.dart';

AppBarController appBarController = Get.put(AppBarController());

class AppBarController extends GetxController {
  appbar() {
    return Container(
      height: ScreenSize.fSize_100(),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorUtilsController.appBarColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
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
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Image.asset(
                          imageUtilController.drawerIcon,
                          scale: 2.0,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
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

  appbar2() {
    return Container(
      height: ScreenSize.fSize_100(),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorUtilsController.appBarColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: ScreenSize.fSize_250(),
              color: Colors.transparent,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenSize.fSize_20(),
                        right: ScreenSize.fSize_20()),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Image.asset(
                          imageUtilController.drawerIcon,
                          scale: 2.0,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
                    child: Text(
                      "GUIDE",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.chakraPetch(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: ScreenSize.fSize_20()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  appbar3() {
    return Container(
      height: ScreenSize.fSize_100(),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorUtilsController.appBarColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fSize_10()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: ScreenSize.fSize_250(),
              color: Colors.transparent,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenSize.fSize_20(),
                        right: ScreenSize.fSize_20()),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Image.asset(
                          imageUtilController.drawerIcon,
                          scale: 2.0,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
                    child: Text(
                      "FAVORITES",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.chakraPetch(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: ScreenSize.fSize_20()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  drawer(BuildContext context, var ontap, var home, var like, var guide) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(imageUtilController.drawerBGImage),
            SizedBox(height: ScreenSize.fSize_15()),
            drawerController.drawerRow(
              context,
              imageUtilController.drawerAllSkinsImage,
              "All Skins",
              home,
              // () {
              //   Get.back();
              //   home = true;
              // },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.likeImage,
              "Favorite Skins",
              like,
              // () {
              //   Get.back();
              //   like = true;
              // },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.guideImage,
              "Guide",
              guide,
              // () {
              //   Get.back();
              //   guide = true;
              // },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.drawerRateImage,
              "Rate Us",
              () async {
                Get.back();
                const url =
                    'https://in.linkedin.com/company/infinitizi?trk=ppro_cprof';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.drawerShareImage,
              "Share",
              () {
                Get.back();
                Share.share(
                    'check out this App https://play.google.com/store/apps?hl=en-IN',
                    subject: 'Look what New!');
              },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.drawerPrivacyImage,
              "Privacy Policy",
              () {
                Get.back();
              },
            ),
            drawerController.drawerRow(
              context,
              imageUtilController.drawerExitImage,
              "Exit",
              ontap,
            ),
          ],
        ),
      ),
    );
  }
}
