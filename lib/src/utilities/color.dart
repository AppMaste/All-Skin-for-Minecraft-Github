import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  var exitAlertBoxColor = [
    const Color(0xFF9188FB),
    const Color(0xFFA23BED),
  ];

  var gridviewContainerColor = [
    const Color(0xFF9188FB).withOpacity(0.4),
    const Color(0xFFA23BED).withOpacity(0.4),
  ];

  var drawerContainerColor = [
    const Color(0xFF9188FB).withOpacity(0.7),
    const Color(0xFFA23BED).withOpacity(0.7),
  ];
  var imageBoxShadowColor = const Color(0xFFA23BED);

  var likeColor = const Color(0xFF9188FB);

  var toastColor = const Color(0xFFA23BED);
}

toastNotification () {
  return Fluttertoast.showToast(
      msg: "Save Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorUtilsController.toastColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
