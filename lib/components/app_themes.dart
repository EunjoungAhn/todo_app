import 'package:todo_app/components/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  //main의 ThemeData를 잘라서 따로 getter로 설정
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: AppColors.primaryMeterialColor,
    fontFamily: 'GmarketSansTTF',
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.white,
    textTheme: _textTheme, //_textTheme을 바라보게 설정
    appBarTheme: appBarTheme,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

//다크 테마 만들기
  static ThemeData get darkTheme => ThemeData(
    primarySwatch: AppColors.primaryMeterialColor,
    fontFamily: 'GmarketSansTTF',
    splashColor: Colors.black,
    textTheme: _textDartTheme, //_textDartTheme을 바라보게 설정
    appBarTheme: appBarDarkTheme,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

// appBar 테마 만들기
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 25,
    ),
    elevation: 0, //appBar 그림자 없애기
  );

  // 다그모드 appBar 테마 만들기
  static const AppBarTheme appBarDarkTheme = AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 25,
    ),
    elevation: 0, //appBar 그림자 없애기
  );

  static const TextTheme _textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      color: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
    labelMedium: TextStyle(
    ),
  );

  //다크모드 글자 색
  static const TextTheme _textDartTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 14,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 32,
      color: Colors.black54,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      color: Colors.black87,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      color: Colors.black87,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      color: Colors.black87,
      fontWeight: FontWeight.w300,
    ),
    labelMedium: TextStyle(
      color: Colors.black87,
    ),
  );

}