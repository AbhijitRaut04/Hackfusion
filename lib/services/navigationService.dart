import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../views/Notifications/notifications.dart';
import '../views/complaints/complaints.dart';
import '../views/home/homePage.dart';
import '../views/profile/profile.dart';
import '../views/search/search.dart';


class NavigationService extends GetxService{
  var currentIndex=0.obs;
  var prevIndex= 0.obs;

  List<Widget> pages(){
    return[
      const HomePage(),
      const Complaints(),
      const Search(),
      const Notifications(),
      const Profile(),
    ];
  }

  // Update current index function
  void updateCurrentIndex(int index){
    prevIndex.value = currentIndex.value;
    currentIndex.value = index;
  }
  // Back to previous page
  void backToPrevPage(){
    currentIndex.value = prevIndex.value;
  }



}