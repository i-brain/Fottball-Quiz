import 'package:Footcer/controller/QandA_controller.dart';
import 'package:Footcer/view/screens/questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayScreen extends StatelessWidget {
  final QandAController controller = Get.put(QandAController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Get.defaultDialog(
          confirm: TextButton(
              onPressed: () {
                Get.offAll(PlayScreen());
              },
              child: Text('Yes')),
          cancel: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('No')),
          content: Text('Do you want to quit?'),
        );
      },
      child: SafeArea(
        child: GetBuilder<QandAController>(initState: (state) {
          controller.loadAllSounds();
        }, builder: (controller) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cl.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: Center(
                      child: MaterialButton(
                        color: Colors.pink,
                        onPressed: () async {
                          controller.timer?.cancel();
                          controller.firstCountdown();
                          controller.fetchData();
                          Get.to(QuestionsScreen());
                        },
                        child: Text(
                          'Play',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
