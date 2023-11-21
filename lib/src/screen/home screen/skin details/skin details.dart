// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:all_skin_for_minecraft/src/widgets/appbar.dart';
import 'package:all_skin_for_minecraft/src/widgets/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utilities/color.dart';
import '../../../utilities/image.dart';
import '../../../widgets/size.dart';

class SkinDetailsScreen extends StatefulWidget {
  const SkinDetailsScreen({super.key});

  @override
  State<SkinDetailsScreen> createState() => _SkinDetailsScreenState();
}

class _SkinDetailsScreenState extends State<SkinDetailsScreen> {
  var argument = Get.arguments;

  double rotation = 0.0;

  File? downloadedFile;

  String downloadMessage = "Press download";

  @override
  Widget build(BuildContext context) {
    print("ARGUMENT $argument");
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: Column(
        children: [
          Container(
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
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                imageUtilController.leftArrowImage,
                                scale: 2.0,
                              ),
                            );
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
                          child: Text(
                            argument[0],
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
                  Padding(
                    padding: EdgeInsets.only(top: ScreenSize.fSize_20()),
                    child: Image.asset(
                      imageUtilController.guideImage,
                      scale: 2.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenSize.fSize_20()),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSize.fSize_8(),
                horizontal: ScreenSize.fSize_15()),
            child: Container(
              height: ScreenSize.horizontalBlockSize! * 110,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colorUtilsController.appBarColor,
                ),
                borderRadius: BorderRadius.circular(ScreenSize.fSize_8()),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                      colors: colorUtilsController.exitAlertBoxColor),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenSize.fSize_20()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: ScreenSize.horizontalBlockSize! * 80,
                        width: double.maxFinite,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform.rotate(
                            angle: rotation,
                            child: Image.network(
                              argument[1],
                              scale: 0.24,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fSize_20()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (ctx) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenSize.fSize_15(),
                                      vertical: ScreenSize.fSize_60()),
                                  child: Container(
                                    // height: ScreenSize.horizontalBlockSize! * 0,
                                    // width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenSize.fSize_15()),
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: colorUtilsController
                                                .exitAlertBoxColor),
                                      ),
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorUtilsController
                                              .imageBoxShadowColor,
                                          spreadRadius: 5,
                                          blurRadius: 30,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  ScreenSize.fSize_15()),
                                              child: Image.asset(
                                                imageUtilController.cancelImage,
                                                scale: 1.8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image.network(
                                          argument[1],
                                          scale: 0.24,
                                          // fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: ScreenSize.fSize_40(),
                              width: ScreenSize.fSize_40(),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: colorUtilsController
                                        .drawerContainerColor,
                                  )),
                              child: Image.asset(
                                imageUtilController.zoomImage,
                                scale: 2.5,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: ScreenSize.fSize_40(),
                              width: ScreenSize.fSize_40(),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: colorUtilsController
                                        .drawerContainerColor,
                                  )),
                              child: Image.asset(
                                imageUtilController.walkImage,
                                scale: 2.5,
                              ),
                            ),
                          ),
                          Container(
                            height: ScreenSize.fSize_40(),
                            width: ScreenSize.fSize_40(),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors:
                                      colorUtilsController.drawerContainerColor,
                                )),
                            child: Image.asset(
                              imageUtilController.playImage,
                              scale: 2.5,
                            ),
                          ),
                          Container(
                            height: ScreenSize.fSize_40(),
                            width: ScreenSize.fSize_40(),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors:
                                      colorUtilsController.drawerContainerColor,
                                )),
                            child: Image.asset(
                              imageUtilController.likeImage,
                              scale: 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenSize.fSize_20()),
          GestureDetector(
            onTap: () async {
              if (await Permission.storage.isDenied) {
                Permission.storage.request();
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.fSize_15(),
                        vertical: ScreenSize.fSize_150()),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Container(
                        // height: ScreenSize.horizontalBlockSize! * 0,
                        // width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenSize.fSize_15()),
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: colorUtilsController.exitAlertBoxColor),
                          ),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: colorUtilsController.imageBoxShadowColor,
                              spreadRadius: 5,
                              blurRadius: 30,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenSize.fSize_15(),
                                vertical: ScreenSize.fSize_10(),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GradientText(
                                    gradientDirection: GradientDirection.ttb,
                                    "EXPORT SKIN",
                                    style: GoogleFonts.chakraPetch(
                                        fontSize: ScreenSize.fSize_20(),
                                        fontWeight: FontWeight.w600),
                                    colors:
                                        colorUtilsController.exitAlertBoxColor,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Image.asset(
                                      imageUtilController.cancelImage,
                                      scale: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenSize.fSize_40()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.fSize_14()),
                              child: Text(
                                appDataController.saveToMinecraftText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.chakraPetch(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenSize.fSize_20()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.fSize_30()),
                              child: GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  toastNotification();
                                  saveMineCraft("${argument[2]}");
                                },
                                child: Container(
                                  height: ScreenSize.horizontalBlockSize! * 14,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenSize.fSize_100()),
                                      gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor)),
                                  child: Center(
                                    child: Text(
                                      "SAVE TO MINECRAFT",
                                      style: GoogleFonts.chakraPetch(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenSize.fSize_17()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenSize.fSize_45()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.fSize_14()),
                              child: Text(
                                appDataController.saveToGallery,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.chakraPetch(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenSize.fSize_20()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.fSize_30()),
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                  toastNotification();
                                  saveGallery("${argument[1]}");
                                },
                                child: Container(
                                  height: ScreenSize.horizontalBlockSize! * 14,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenSize.fSize_100()),
                                      gradient: LinearGradient(
                                          colors: colorUtilsController
                                              .exitAlertBoxColor)),
                                  child: Center(
                                    child: Text(
                                      "SAVE TO GALLERY",
                                      style: GoogleFonts.chakraPetch(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenSize.fSize_17()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: ScreenSize.fSize_40(),
              width: ScreenSize.fSize_150(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenSize.fSize_100()),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colorUtilsController.exitAlertBoxColor,
                ),
              ),
              child: Center(
                child: Text(
                  "Download",
                  style: GoogleFonts.chakraPetch(
                      color: Colors.white,
                      fontSize: ScreenSize.fSize_16(),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveGallery(String image) async {
    // await _askPermission();
    var response = await Dio()
        .get(image, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    // Navigator.pop(context);
  }

  saveMineCraft(String image) async {
    // await _askPermission();
    var response = await Dio()
        .get(image, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
    );
    print(result);
    // Navigator.pop(context);
  }
}
