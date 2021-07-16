import 'package:Footcer/controller/QandA_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JokerCircle extends StatelessWidget {
  final QandAController controller = Get.put(QandAController());

  final isPhone;
  final isPeople;

  JokerCircle({this.isPeople = false, this.isPhone = false});
  @override
  Widget build(BuildContext context) {
    return GetX<QandAController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          controller.isDialogOpen.value = true;
          if (!controller.isVariantSelected.value) {
            if (isPhone) {
              if (!controller.isPhoneJokerUsed.value) {
                Get.defaultDialog(
                  backgroundColor: Colors.yellow[200],
                  onWillPop: () {},
                  barrierDismissible: false,
                  title: 'Calling friend...',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Your friend says the answer :',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${controller.trueAnswer}',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  confirm: GestureDetector(
                    onTap: () {
                      controller.isDialogOpen.value = false;
                      Get.back();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Text('Okay'),
                      ),
                    ),
                  ),
                );
                controller.isPhoneJokerUsed.value = true;
              }
            } else if (isPeople) {
              if (!controller.isPeopleJokerUsed.value) {
                Get.defaultDialog(
                  backgroundColor: Colors.yellow[200],
                  onWillPop: () {},
                  barrierDismissible: false,
                  title: 'People\'s answers',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Most selected answer from audition :',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${controller.trueAnswer}',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  confirm: GestureDetector(
                    onTap: () {
                      controller.isDialogOpen.value = false;
                      Get.back();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Text('Okay'),
                      ),
                    ),
                  ),
                );
                controller.isPeopleJokerUsed.value = true;
              }
            }
          }
        },
        child: Container(
          height: 40,
          width: 40,
          child: Center(
            child: isPhone ? Icon(Icons.phone) : Icon(Icons.people),
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            shape: BoxShape.circle,
            color: (() {
              if (isPhone) {
                if (!controller.isPhoneJokerUsed.value) return Colors.blue;
                return Colors.grey;
              } else if (isPeople) {
                if (!controller.isPeopleJokerUsed.value) return Colors.blue;
                return Colors.grey;
              }
            }()),
          ),
        ),
      );
    });
  }
}
