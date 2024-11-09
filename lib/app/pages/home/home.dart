import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class HomeView extends GetView<GetxController>{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
   return const Scaffold(
    body: SafeArea(child:Text('Home Page')),
   );
  }

}