import 'package:Footcer/controller/QandA_controller.dart';
import 'package:Footcer/view/screens/play_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AnswerCard extends StatelessWidget {
  final String answerText;

  final QandAController controller = Get.put(QandAController());
  Rx<MaterialColor> color = Colors.deepPurple.obs;

  onTap() async {
    if (!controller.isVariantSelected.value &&
        !controller.fiftyJokerVariantCheck(answerText)) {
      controller.isVariantSelected.value = true;
      color.value = Colors.yellow;

      controller.audioPlayer.stop();
      controller.timer.cancel();
      Future.delayed(1.seconds).then((value) async {
        if (!controller.isAnswerTrue(answerText)) {
          color.value = Colors.red;
          if (controller.isSoundOn.value)
            await controller.audioCache.play(
              'sounds/wrong.mp3',
            );
          controller.isTap.toggle();

          Get.defaultDialog(
            backgroundColor: Colors.red,
            barrierDismissible: false,
            title: 'Game Over',
            titleStyle: TextStyle(color: Colors.white),
            content: Column(
              children: [
                controller.currentIndex.value > 1
                    ? Text(
                        'You answered  ${controller.currentIndex.value}  questions right.',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        'You answered  ${controller.currentIndex.value}  question right.',
                        style: TextStyle(color: Colors.white),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        padding: EdgeInsets.only(top: 20),
                        iconSize: 40,
                        icon: Icon(Icons.home),
                        color: Colors.white,
                        onPressed: () {
                          Get.offAll(PlayScreen());
                        }),
                    IconButton(
                      padding: EdgeInsets.only(top: 20),
                      onPressed: () {
                        controller.fetchData();
                        controller.firstCountdown();
                        if (controller.isDialogOpen.value) {
                          Get.back();
                          Get.back();
                          controller.isDialogOpen.value = false;
                        } else
                          Get.back();
                      },
                      icon: Icon(Icons.cached),
                      iconSize: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          );
        } else {
          if (controller.isSoundOn.value)
            await controller.audioCache.play('sounds/correct.mp3');
          color.value = Colors.green;

          if (controller.currentIndex.value < 9) {
            controller.isTap.toggle();

            Future.delayed(1.seconds).then((value) {
              controller.currentIndex++;
              controller.makeRandomAnswersList();
              if (controller.isFiftyJokerPressed.value)
                controller.isFiftyJokerUsed.value = true;
              controller.isFiftyJokerPressed.value = false;

              controller.isVariantSelected.value = false;
              controller.setCounter();

              controller.isTap.toggle();
            });
          } else if (controller.currentIndex.value == 9) {
            controller.isWon.value = true;
            Future.delayed(1.seconds, () async {
              if (controller.isSoundOn.value)
                controller.audioPlayer =
                    await controller.audioCache.play('sounds/uefa.mp3');
              controller.confettiController.play();
              Get.defaultDialog(
                backgroundColor: Colors.black,
                barrierDismissible: true,
                title: 'You Won',
                titleStyle: TextStyle(color: Colors.cyan),
                content: Stack(
                  children: [
                    Image.asset(
                      'assets/images/congrats.jpg',
                      fit: BoxFit.fill,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        numberOfParticles: 15,
                        emissionFrequency: 0.1,
                        confettiController: controller.confettiController,
                        blastDirectionality: BlastDirectionality
                            .explosive, // don't specify a direction, blast randomly
                        // start again as soon as the animation is finished
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ], // manually specify the colors to be used
                      ),
                    ),
                  ],
                ),
                confirm: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    Get.offAll(PlayScreen());
                  },
                  child: Text('Done'),
                ),
              );
            });
          }
        }
      });
    }
  }

  AnswerCard({this.answerText});
  @override
  Widget build(BuildContext context) {
    return GetX<QandAController>(dispose: (state) {
      controller.timer.cancel();
    }, builder: (controller) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (() {
                if (controller.isTap.value &&
                        controller.isAnswerTrue(answerText) ||
                    controller.isTime.value &&
                        controller.isAnswerTrue(answerText))
                  return Colors.green;
                else if (controller.isFiftyJokerPressed.value &&
                    controller.fiftyJokerVariantCheck(answerText))
                  return Colors.grey;
                return color.value;
              }())),
          child: Center(
            child: Text(
              answerText,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),
      );
    });
  }
}
