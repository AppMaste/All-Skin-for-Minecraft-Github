import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen {
  favorite() {
    return Container(
      height: ScreenSize.horizontalBlockSize! * 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageUtilController.listEmptyImage,
              scale: 2.0,
            ),
            Text(
              "LIST IS EMPTY",
              style: GoogleFonts.chakraPetch(
                color: Colors.white,
                fontSize: ScreenSize.fSize_17(),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
