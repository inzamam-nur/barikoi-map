import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Link3 Self Care',style: TextStyle(color: Colors.white)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.accentPrimary,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          SystemNavigator.pop();
          return false;
          },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(left: 24,right: 24, top: 24),
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 40,bottom: 40, left: 16, right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Lottie.asset(AppImages.noInternetLottie, repeat: false),
                        const Text('No Internet Connection',style: TextStyle(fontSize: 16,color:Colors.black, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,),
                        const Text('Try these steps to get back to online:',style: TextStyle(fontSize: 14,color: AppColors.gray),),
                        const SizedBox(height: 8,),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          child: const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle_rounded,color: AppColors.accentPrimary,size: 20,),
                                  SizedBox(width: 8,),
                                  Text('Check your mobile data or router',style: TextStyle(fontSize: 16,color: AppColors.gray)),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle_rounded,color: AppColors.accentPrimary,size: 20,),
                                  SizedBox(width: 8,),
                                  Text('Reconnect to internet',style: TextStyle(fontSize: 16,color: AppColors.gray)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(left: 24,right: 24, top: 24),
                  child:  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_sharp, color: Colors.pink,),
                        SizedBox(width: 16,),
                        Text('You are currently offline', style: TextStyle(color: Colors.pink),)
                      ],
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
}
