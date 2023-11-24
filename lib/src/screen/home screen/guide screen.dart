import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../service/ads.dart';

class GuideScreen {
  List image = [
    "assets/guide image/image 1.jpg",
    "assets/guide image/image 2.jpg",
    "assets/guide image/image 3.jpg",
    "assets/guide image/image 4.jpg",
  ];

  guide(BuildContext context,String page) {
    return Container(
      height: ScreenSize.horizontalBlockSize! * 155,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: ScreenSize.fSize_8(),
          right: ScreenSize.fSize_8(),
          bottom: ScreenSize.fSize_15()
        ),
        child: SingleChildScrollView(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                  child: (index + 1) % 3 == 0
                      ? FutureBuilder(
                    builder: (context, snapshot) {
                      return snapshot.connectionState ==
                          ConnectionState.done
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1, 2),
                                    blurRadius: 5)
                              ]),
                          height: ScreenSize.fSize_250(),
                          // child: const Center(
                          //   child: Text("Hello"),
                          // ),
                          child: AdWidget(
                            ad: snapshot.data,
                            key: Key(index.toString()),
                          ),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: ScreenSize.fSize_250(),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1, 2),
                                    blurRadius: 5)
                              ]),
                          child: Center(
                            child: Text(
                              "Ad is Loading.......",
                              style: TextStyle(
                                  fontSize: ScreenSize
                                      .fSize_20(),
                                  fontWeight:
                                  FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    },
                    future: native.getData(page),
                  )
                      : Container());
            },
          ),
        ),
      ),
    );
  }
}
