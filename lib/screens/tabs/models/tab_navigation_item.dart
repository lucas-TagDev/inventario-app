import 'package:flutter/material.dart';

import '../../home.dart';
import '../../profile.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: Home(),
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),

    TabNavigationItem(
      page: Profile(),
      icon: Icon(Icons.person_outline_rounded),
      title: Text("Perfil"),
    ),

     /*
    TabNavigationItem(
      page: SearchPage(),
      icon: Icon(Icons.search),
      title: Text("Search"),
    ),*/
  ];
}