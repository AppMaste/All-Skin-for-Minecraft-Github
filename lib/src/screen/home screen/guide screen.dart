import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GuideScreen {
  List image = [
    "assets/guide image/image 1.jpg",
    "assets/guide image/image 2.jpg",
    "assets/guide image/image 3.jpg",
    "assets/guide image/image 4.jpg",
  ];

  guide(BuildContext context) {
    return Container(
      height: ScreenSize.horizontalBlockSize! * 155,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: ScreenSize.fSize_8(),
          right: ScreenSize.fSize_8(),
          bottom: ScreenSize.fSize_15()
        ),
        child: ListView.builder(
          itemCount: image.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step ${index + 1}",
                  style: GoogleFonts.chakraPetch(
                      color: Colors.white, fontSize: ScreenSize.fSize_20()),
                ),
                SizedBox(height: ScreenSize.fSize_10()),
                Image.asset(image[index]),
                SizedBox(height: ScreenSize.fSize_20()),
              ],
            );
          },
        ),
      ),
    );
  }
}
