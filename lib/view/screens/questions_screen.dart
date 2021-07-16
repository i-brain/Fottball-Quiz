import 'package:Footcer/controller/QandA_controller.dart';
import 'package:Footcer/view/screens/play_screen.dart';
import 'package:Footcer/view/widgets/answer_card.dart';
import 'package:Footcer/view/widgets/fifty_joker.dart';
import 'package:Footcer/view/widgets/joker_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuestionsScreen extends StatelessWidget {
  final QandAController controller = Get.put(QandAController());

  Future<bool> onBackPressed() {
    return Get.defaultDialog(
      content: Text('Do you want to go home?'),
      cancel: Padding(
        padding: const EdgeInsets.only(right: 50, bottom: 15),
        child: TextButton(onPressed: () => Get.back(), child: Text('No')),
      ),
      confirm: TextButton(
          onPressed: () => Get.offAll(PlayScreen()), child: Text('Yes')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SafeArea(
          child: GetX<QandAController>(dispose: (state) {
            controller.timer.cancel();
            controller.countdownTimer.cancel();
            controller.audioPlayer?.stop();
          }, builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/cl.jpg',
                    ),
                    fit: BoxFit.fill),
              ),
              child: controller.countdownCounter.value > 0
                  ? Center(
                      child: Text(
                      '${controller.countdownCounter.value}',
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      content: Text('Do you want to go home?'),
                                      cancel: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 50, bottom: 15),
                                        child: TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text('No')),
                                      ),
                                      confirm: TextButton(
                                          onPressed: () =>
                                              Get.offAll(PlayScreen()),
                                          child: Text('Yes')),
                                    );
                                  }),
                              IconButton(
                                  icon: Icon(
                                      controller.isSoundOn.value
                                          ? Icons.volume_up
                                          : Icons.volume_off_rounded,
                                      color: Colors.white,
                                      size: 35),
                                  onPressed: () {
                                    controller.isSoundOn.toggle();
                                  }),
                              SizedBox(
                                width: 90,
                              ),
                              FiftyJoker(),
                              SizedBox(
                                width: 15,
                              ),
                              JokerCircle(
                                isPhone: true,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              JokerCircle(
                                isPeople: true,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            'Question  ${controller.currentIndex.value + 1}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                      TextSpan(
                                        text: '/10',
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        controller.counter.value.toString(),
                                        style: TextStyle(
                                            color: controller.counter.value < 6
                                                ? Colors.red
                                                : Colors.white,
                                            fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.timer,
                                        color: controller.counter.value < 6
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: StepProgressIndicator(
                                totalSteps: 10,
                                currentStep: !controller.isWon.value
                                    ? controller.currentIndex.value
                                    : controller.currentIndex.value + 1,
                                size: 8,
                                selectedColor: Colors.green[700],
                                unselectedColor: Colors.grey[200],
                                customStep: (index, color, _) => Container(
                                      color: color,
                                    )),
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.symmetric(
                              vertical: 80,
                              horizontal: 10,
                            ),
                            child: Center(
                              child: Text(
                                controller.currentQuestion(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            height: 260,
                            // color: Colors.red,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: AnswerCard(
                                      answerText: controller.answersList[index],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }
}
