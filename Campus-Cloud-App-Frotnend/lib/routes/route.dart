import 'package:campus_cloud/views/complaints/showAllComplaints.dart';
import 'package:campus_cloud/views/dispensaryAppointment/dispensaryAppointment.dart';
import 'package:campus_cloud/views/election/election.dart';
import 'package:campus_cloud/views/election/result.dart';
import 'package:campus_cloud/views/facilityBooking/allBookings.dart';
import 'package:campus_cloud/views/facilityBooking/facilityBooking.dart';
import 'package:campus_cloud/views/writeApplication/writeApplication.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../auth/login.dart';
import '../auth/register.dart';
import '../views/chatbot/chatbot.dart';
import '../views/cheatingStudents/cheatingStudents.dart';
import '../views/complaints/complaints.dart';
import '../views/election/noElections.dart';
import '../views/election/voting.dart';
import '../views/home.dart';
import '../views/profile/editProfile.dart';
import '../views/settings/settings.dart';
import '../views/showImage/showImage.dart';
import 'RouteNames.dart';

class Routes{
  static final pages=[

    GetPage(name: RouteNames.Home,page: () => Home()),
    GetPage(name: RouteNames.Login, page: () =>const Login()),
    GetPage(name: RouteNames.Signup, page: () =>const Signup()),
    GetPage(name: RouteNames.EditProfile, page: () =>const Editprofile(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.Settings, page: () =>Setting(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.Complaint, page: () =>Complaints(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.WriteApplication, page: () =>WriteApplication(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.ShowImage, page: () =>ShowImage(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.Chatbot, page: () =>const ChatBot(),transition: Transition.downToUp),
    GetPage(name: RouteNames.CheatingStudents, page: () =>const CheatingStudents(),transition: Transition.downToUp),
    GetPage(name: RouteNames.Election, page: () =>const Election(),transition: Transition.downToUp),
    GetPage(name: RouteNames.Voting, page: () =>const VoteNowPage(),transition: Transition.downToUp),
    GetPage(name: RouteNames.CampusBooking, page: () =>BookingPage(),transition: Transition.downToUp),
    //GetPage(name: RouteNames.IdProof, page: () =>IdProof(),transition: Transition.downToUp),
    GetPage(name: RouteNames.NoElections, page: () =>NoElections(),transition: Transition.downToUp),
    GetPage(name: RouteNames.ElectionResults, page: () =>ElectionResults(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.DispensaryAppointment, page: () =>DispensaryAppointmentPage(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.StudentsComplaints, page: () =>StudentsComplaints(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.AllBookings, page: () =>AllBookings(),transition: Transition.leftToRight),
  ];
}