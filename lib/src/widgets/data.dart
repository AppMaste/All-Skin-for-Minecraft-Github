import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppData appDataController = Get.put(AppData());

class AppData extends GetxController {
  var trendingData = [
    "SLIME",
    "HARVEST",
    "IIRAK-DINO",
    "CROMA CRUSE",
    "ME AGAIN",
    "IIRAK-DINO",
    "SLIME",
    "CHIKA",
    "WONDER MARIO",
  ].obs;

  var saveToMinecraftText =
      "Click the SAVE TO MINECRAFT button to start the skin installation process. Please skip this step if you already have it installed.";

  var saveToGallery =
      "Press yhe SAVE TO GALLERY button to start the download process. Please skip this step if you already have it downloaded.";
}
