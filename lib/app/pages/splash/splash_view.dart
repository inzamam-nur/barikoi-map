import 'package:barikoi/app/pages/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';



class SplashScreenView extends GetView<SplashController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          top: false,
            child:Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff0000), Color(0xff0000)],
                    stops: [0, 1],
                  )
              ),
              child:  Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/barikoi-logo-black.svg',height: 50,width: 50),
                      ],
                    ),
                  ),
                  Positioned(bottom:40, left: 0, right: 0,
                      child:  Column(
                        children: [
                          Text("${controller.copyright}",textAlign: TextAlign.center,style: TextStyle(fontSize: 12)),
                        ],
                      ))
                ],

              ),
            ))
    );
  }


}

