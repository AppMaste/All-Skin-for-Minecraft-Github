// ignore_for_file: invalid_use_of_protected_member

import 'package:all_skin_for_minecraft/src/screen/home%20screen/home%20screen.dart';
import 'package:all_skin_for_minecraft/src/screen/home%20screen/skin%20details/skin%20details.dart';
import 'package:all_skin_for_minecraft/src/service/ads.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../utilities/color.dart';

class FavoriteScreen {
  favorite(BuildContext context) {
    // print("LIKEDATA ${HomeScreenState().likeTitleData.value}");
    // print("LIKEDATA $likeIDData");
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.7;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: ScreenSize.horizontalBlockSize! * 142,
        child: likeTitleData.value.isNotEmpty
            ? GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: (itemWidth / itemHeight),
                  // childAspectRatio: 20 / 10,
                  mainAxisSpacing: ScreenSize.fSize_15(),
                  crossAxisSpacing: ScreenSize.fSize_10(),
                ),
                // controller: scrollController,
                itemCount: likeTitleData.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      adController.adButton(
                        context,
                        "/SkinDetailsScreen",
                        "/HomeScreen",
                        [
                          likeIDData.value[index],
                          likeTitleData.value[index],
                        ],
                      );
                      // Get.to(
                      //   () => const SkinDetailsScreen(),
                      //   arguments: [
                      //     likeIDData.value[index],
                      //     likeTitleData.value[index],
                      //   ],
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colorUtilsController.appBarColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(ScreenSize.fSize_8()),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                              colors: colorUtilsController.exitAlertBoxColor),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: ScreenSize.fSize_10()),
                              child: Image.network(
                                "http://owlsup.ru/main_catalog/skins/${likeIDData.value[index]}/skinIMG.png",
                                scale: 1.8,
                                errorBuilder: (context, object, stacktrace) {
                                  debugPrint("object : ${object.toString()}");
                                  debugPrint(
                                      "stacktrace : ${stacktrace.toString()}");
                                  return Icon(
                                    Icons.error,
                                    size: ScreenSize.fSize_30(),
                                    color: Colors.red,
                                  );
                                },
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
                                        ScreenSize.horizontalBlockSize! * 2),
                                    bottomRight: Radius.circular(
                                        ScreenSize.horizontalBlockSize! * 2)),
                              ),
                              child: Center(
                                child: Text(
                                  likeTitleData.value[index],
                                  // "data",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.chakraPetch(
                                      color: Colors.white,
                                      fontSize: ScreenSize.fSize_14()),
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
                                  onTap: () {
                                    likeTitleData.removeAt(index);
                                    likeTitleData.refresh();
                                  },
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    size: ScreenSize.fSize_20(),
                                    color: colorUtilsController.likeColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // }
                },
              )
            : Center(
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
      ),
    );
  }
}
