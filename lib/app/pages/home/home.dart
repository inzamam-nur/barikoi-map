import 'package:barikoi/app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController>{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
   return const Scaffold(
    body: SafeArea(child:Text('Home Page')),
   );
  }

}