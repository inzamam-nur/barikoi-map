import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class DefaultAppBtn extends GetView {

  const DefaultAppBtn({
    super.key,
    required this.title,
    required this.onClick,
    this.textSize = 18,
    this.textColor = Colors.white,
    this.backgroundColor = AppColors.primary,
    this.btnHeight = 50,
    this.btnWidth = double.infinity,
    this.isFillBtn = true,
    this.disableButton = false,
  });

  final String title;
  final Color textColor;
  final double textSize;
  final double btnWidth ;
  final double btnHeight;
  final bool isFillBtn;
  final bool disableButton;
  final Color backgroundColor;
  final VoidCallback? onClick;


  @override
  Widget build(BuildContext context) {
    var btnColors = disableButton ? AppColors.grayLight : backgroundColor;
    ButtonStyle style = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(isFillBtn ? btnColors: Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isFillBtn ? BorderSide.none:BorderSide(color: btnColors,width: 2),
          )
      ),
    );

    return SizedBox(width: btnWidth, height: btnHeight,
      child: ElevatedButton(
        onPressed: disableButton ? null : onClick,
        style: style,
        child: Text(title,
          style: TextStyle(
              color: isFillBtn ? textColor : backgroundColor,
              fontSize: textSize,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class DefaultSizeAppBtn extends GetView {

  const DefaultSizeAppBtn({
    Key? key,
    required this.title,
    required this.onClick,
    this.textSize = 22,
    this.textColor = Colors.white,
    this.backgroundColor = AppColors.primary,

    this.isFillBtn = true,
    this.disableButton = false,
  }) : super(key: key);

  final String title;
  final Color textColor;
  final double textSize;
  final bool isFillBtn;
  final bool disableButton;
  final Color backgroundColor;
  final VoidCallback? onClick;


  @override
  Widget build(BuildContext context) {
    var btnColors = disableButton ? AppColors.grayLight : backgroundColor;
    ButtonStyle style = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(isFillBtn ? btnColors: Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: isFillBtn ? BorderSide.none:BorderSide(color: btnColors,width: 1),
          )
      ),
    );

    return ElevatedButton(
      onPressed: disableButton ? null : onClick,
      style: style,
      child: Text(title, textAlign: TextAlign.center,
        style: TextStyle(
            color: isFillBtn ? textColor : backgroundColor,
            fontSize: textSize,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}


class ResizeAbleBtn extends GetView {
  const ResizeAbleBtn({
    Key? key,
    required this.title,
    required this.onClick,
    this.textSize = 16,
  }) : super(key: key);

  final String title;
  final double textSize;
  final GestureTapCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primary15,
      highlightColor: AppColors.primary.withOpacity(0.1),
      onTap: onClick,
      child: Ink(
        child: Container(
          padding: const EdgeInsets.only(left: 8,right: 8, top: 4,bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.primary)
          ),
          child: Text(title,style: TextStyle(color: AppColors.primary,fontSize: textSize)),
        ),
      ),
    );
  }
}


