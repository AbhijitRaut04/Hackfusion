import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notificationController.dart';
import '../../services/navigationService.dart';
import '../../utils/helper.dart';
import '../widgets/imageAvatar.dart';
import '../widgets/loading.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController controller=Get.put(NotificationController());
  @override
  void initState(){
    controller.fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
          leading:
          IconButton(onPressed: () => Get.find<NavigationService>().backToPrevPage(), icon: const Icon(Icons.close)),),
        body: SingleChildScrollView(
          child: Obx(() =>controller.loading.value ? const Loading() : Column(
            children: [
              if(controller.notifications.isNotEmpty)
                ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context,index) => Column(
                      children: [
                        ListTile(
                          leading: ImageAvatar(radius: 20),
                          trailing: Text(formatDateTime(controller.notifications[index].createdAt!)),
                          subtitle: Text(controller.notifications[index].description!),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: Color(0xff242424),
                          ),
                        )
                      ],
                    )
                )
              else
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No notification found !",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                )
            ],

          ),
          ),
        )
    );;
  }
}
