import 'package:coronavirus_stats_app/Screen/home.dart';
import 'package:flutter/material.dart';


void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Covid-19 Stats',
  home: HomeScreen(),
  theme: ThemeData(
    primaryColor: Color(0xff041A37)
  ),
));
