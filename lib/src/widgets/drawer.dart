import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/color.dart';

DrawerWidget drawerController = Get.put(DrawerWidget());

class DrawerWidget extends GetxController {
  drawerRow(BuildContext context, String image, String title,var ontap) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenSize.fSize_20(),
          top: ScreenSize.fSize_20()),
      child: GestureDetector(
        onTap: ontap,
        child: Row(
          children: [
            Container(
              height: ScreenSize.fSize_45(),
              width: ScreenSize.fSize_45(),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colorUtilsController.drawerContainerColor,
                  )),
              child: Image.asset(
                image,
                scale: 2.0,
              ),
            ),
            SizedBox(width: ScreenSize.fSize_20()),
            Text(
              title,
              style: GoogleFonts.chakraPetch(
                  color: Colors.white,
                  fontSize: ScreenSize.fSize_17(),
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
