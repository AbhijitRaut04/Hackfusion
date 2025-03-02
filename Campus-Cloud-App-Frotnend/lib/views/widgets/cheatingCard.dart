import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routeNames.dart';
import '../widgets/imageAvatar.dart';


class CheatingCard extends StatelessWidget {
  final String name;
  final String registrationNumber;
  final String branch;
  final String description;
  final String proof;

  const CheatingCard({
    super.key,
    required this.name,
    required this.registrationNumber,
    required this.branch,
    required this.description,
    required this.proof,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: context.width * 0.12,
                    child: ImageAvatar(radius: 30,),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Text(registrationNumber,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      //Text(registrationNumber,style: TextStyle(fontSize: 15,),),
                      Text(branch,style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,bottom: 5),
            child: Row(
              children: [
                Text(description),
              ],
            ),
          ),
          SizedBox(
            width: context.width * 0.80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(true)
                  GestureDetector(
                    onTap: ()=> {
                      Get.toNamed(RouteNames.ShowImage,arguments: proof)
                    },
                    child: ConstrainedBox(constraints: BoxConstraints(
                        maxHeight: context.height * 0.60,
                        maxWidth: context.width * 0.80
                    ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(proof,fit: BoxFit.cover,alignment: Alignment.topCenter,),
                      ),
                    ),
                  )
              ],
            ),
          ),
          const Divider(
            color: Color(0xff242424),thickness: 0.3,
          )
        ],
      ),
    );
  }
}
