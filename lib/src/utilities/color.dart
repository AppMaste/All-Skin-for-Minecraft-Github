import 'package:flutter/material.dart';
import 'package:get/get.dart';


ColorUtils colorUtilsController = Get.put(ColorUtils());

class ColorUtils extends GetxController {
  var backgroundColor = [
    const Color(0xFF15123D),
    const Color(0xFF2C133F),
  ];

  var appBarColor = [
    const Color(0xFF9286FB).withOpacity(0.3),
    const Color(0xFFA141EE).withOpacity(0.3),
  ];
}