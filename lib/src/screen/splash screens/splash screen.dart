import 'package:all_skin_for_minecraft/src/utilities/color.dart';
import 'package:all_skin_for_minecraft/src/utilities/image.dart';
import 'package:all_skin_for_minecraft/src/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home screen/firebase data config/data config.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

  ConfigData configDataController = Get.put(ConfigData());


  @override
  Widget build(BuildContext context) {
    ScreenSize.sizerInit(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: colorUtilsController.backgroundColor,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ]
                ),
                child: Image.asset(
                  imageUtilController.logoImage,
                  scale: 2.5,
                ),
              ),
              SizedBox(height: ScreenSize.fSize_45()),
              Image.asset(
                imageUtilController.allSkinImage,
              ),
              SizedBox(height: ScreenSize.fSize_20()),
              Image.asset(
                imageUtilController.minecraftTextImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
