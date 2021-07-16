import 'package:Footcer/controller/QandA_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FiftyJoker extends StatelessWidget {
  QandAController controller = Get.put(QandAController());
  @override
  Widget build(BuildContext context) {
    return GetX<QandAController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          if (!controller.isVariantSelected.value) {
            print('50%');
            if (!controller.isFiftyJokerPressed.value) {
              print('bura girdi');
              if (!controller.isFiftyJokerUsed.value) {
                controller.shufleWrongAnswers();

                controller.isFiftyJokerPressed.value = true;
              }
            }
          }
        },
        child: Container(
          height: 40,
          width: 40,
          child: Center(
            child: Text(
              '50/50',
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            shape: BoxShape.circle,
            color: controller.isFiftyJokerUsed.value ||
                    controller.isFiftyJokerPressed.value
                ? Colors.grey
                : Colors.blue,
          ),
        ),
      );
    });
    
  }
}
