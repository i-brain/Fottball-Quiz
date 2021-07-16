import 'dart:async';

import 'package:Footcer/models/QandA.dart';
import 'package:Footcer/view/screens/play_screen.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class QandAController extends GetxController {
  RxBool isWon = false.obs;
  RxBool isDialogOpen = false.obs;
  Rx<ThemeMode> mode = ThemeMode.light.obs;
  final ConfettiController confettiController =
      ConfettiController(duration: Duration(milliseconds: 1500));
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isSoundOn = true.obs;
  RxInt currentIndex = 0.obs;
  RxInt counter = 15.obs;
  Timer timer;
  Timer countdownTimer;
  RxInt countdownCounter = 0.obs;
  RxBool isVariantSelected = false.obs;
  RxBool isTap = false.obs;
  RxBool isTime = false.obs;
  List<String> falseAnswersList = [];
  RxBool isFiftyJokerPressed = false.obs;
  RxBool isFiftyJokerUsed = false.obs;
  RxBool isPhoneJokerUsed = false.obs;
  RxBool isPeopleJokerUsed = false.obs;
  String trueAnswer;
  RxList<dynamic> answersList = [].obs;
  RxList<QandA> qandaList = [
    // QandA(
    //     answerMap: {
    //       'Barney Stinson': false,
    //       'Sherlock Holmes': false,
    //       'Ragnar Lothbork': true,
    //       'Professor': false
    //     },
    //     question:
    //         'Which character used this line in a serie, "Who wants to be king?" ?'),
    // QandA(answerMap: {
    //   'Vikings': false,
    //   'La Casa de Papel': false,
    //   'Prison Break': false,
    //   'Breaking Bad': true
    // }, question: 'Which serie has more IMDB point?'),
    // QandA(
    //     answerMap: {
    //       'Grace': true,
    //       'Martzia': false,
    //       'Lily': false,
    //       'Jane': false
    //     },
    //     question:
    //         'What is the name of Thomas Shelby\'s wife in Peaky Blinders?'),
    // QandA(answerMap: {
    //   'The game is on': false,
    //   'Plata o Plomo': false,
    //   'don\'t suit up': false,
    //   'legend wait for it... dary': true,
    // }, question: 'Which phrase belongs to Barney Stinson?'),
    // QandA(
    //     answerMap: {
    //       'The end of the fu**ing world': true,
    //       'How to sell drugs online (fast)': false,
    //       'After life': false,
    //       'Friends': false
    //     },
    //     question:
    //         'In which serie main boy first wants to kill a girl, but then fall in love with her?'),
    // QandA(answerMap: {
    //   'Rick and Morty': false,
    //   'Black Mirror': false,
    //   'Witcher': false,
    //   'Queen\'s Gambit': true
    // }, question: 'Which serie is about Chess?'),
    // QandA(answerMap: {
    //   '13': true,
    //   '12': false,
    //   '11': false,
    //   '14': false,
    // }, question: 'For how many reasons Hannah Baker suicide?'),
    // QandA(answerMap: {
    //   'Barney': true,
    //   'Marshall': false,
    //   'Robin': false,
    //   'Ted': false
    // }, question: 'The name of which character\'s job is "P.L.E.A.S.E"?'),
    // QandA(answerMap: {
    //   'How I Met Your Mother': true,
    //   'Prison Break': false,
    //   'Daredevil': false,
    //   'Punisher': false
    // }, question: 'Which serie has more seasons?'),
    // QandA(answerMap: {
    //   'Leonardo Dicaprio': true,
    //   'Tom Hardy': false,
    //   'Brad Pitt': false,
    //   'Jhonny Deep': false
    // }, question: 'Which actor won oscar in 2016?'),
    QandA(answerMap: {
      'Lionel Messi': true,
      'Cristiano Ronaldo': false,
      'Kaka': false,
      'Ronaldinho': false
    }, question: 'Which football player is most time Ballon D\'or winner?'),
    QandA(answerMap: {
      'Cristiano Ronaldo': false,
      'Ronaldo (Brasil)': false,
      'Lionel Messi': true,
      'Raul Gonzales': false
    }, question: 'Which football player is most time Golden Shoe winner?'),
    QandA(answerMap: {
      'Milan': false,
      'Real Madrid': true,
      'Liverpool': false,
      'Barcelona': false
    }, question: 'Which team has won the most Champions League titles?'),
    QandA(answerMap: {
      'Mbappe': false,
      'Bale': false,
      'Pogba': false,
      'Neymar': true,
    }, question: 'Who is the most valuable transfer of all time?'),
    QandA(answerMap: {
      'Ronaldinho': false,
      'Messi': false,
      'Vaqif Cavadov': true,
      'Maradona': false
    }, question: 'Which football player is also called alien?'),
    QandA(
        answerMap: {
          'Samuel Eto\'o': false,
          'Rooney': false,
          'Di Maria': true,
          'Pique': false
        },
        question:
            'Which player has played with Messi, Ronaldo, Neymar, Ibrahimovic and Lingard?'),
    QandA(answerMap: {
      'Falcao': false,
      'Lewandovski': true,
      'Ronaldo (Brasil)': false,
      'Halland': false
    }, question: 'Which player scored 5 goals in 9 minutes?'),
    QandA(
        answerMap: {
          'Rooney': false,
          'Suarez': false,
          'Vardy': false,
          'Mane': true,
        },
        question:
            'Who has scored the fastest Premier League hat trick? (two minutes and 56 seconds )'),
    QandA(answerMap: {
      'Liverpool': false,
      'Arsenal': true,
      'Man United': false,
      'Chelsea': false
    }, question: 'Which team won Premier League unbeaten?'),
    QandA(answerMap: {
      'Arshavin': false,
      'Robin van Persie': false,
      'Roberto Carlos': false,
      'Maradona': true,
    }, question: 'Which player scored the goal known as "hand of god"?'),
  ].obs;

  String currentQuestion() {
    return qandaList[currentIndex.value].question;
  }

  makeRandomAnswersList() {
    answersList.clear();
    falseAnswersList.clear();
    qandaList[currentIndex.value].answerMap.forEach((key, value) {
      if (!value && falseAnswersList.length < 3)
        falseAnswersList.add(key);
      else if (value) trueAnswer = key;

      answersList.add(key);
    });

    answersList.shuffle();
  }

  bool isAnswerTrue(String answerText) {
    return qandaList[currentIndex.value].answerMap[answerText];
  }

  fetchData() async {
    qandaList.shuffle();
    await loadAllSounds();
    currentIndex.value = 0;
    falseAnswersList.clear();
    makeRandomAnswersList();
    isWon.value = false;
    isTime.value = false;
    isFiftyJokerPressed.value = false;
    isFiftyJokerUsed.value = false;
    isTap.value = false;
    isVariantSelected.value = false;
    isPhoneJokerUsed.value = false;
    isPeopleJokerUsed.value = false;
  }

  loadAllSounds() {
    audioCache.loadAll([
      'sounds/fiveSeconds.mp3',
      'sounds/uefa.mp3',
      'sounds/wrong.mp3',
      'sounds/correct.mp3',
    ]);
  }

  firstCountdown() async {
    countdownCounter.value = 3;

    countdownTimer = Timer.periodic(0.8.seconds, (timer) async {
      if (countdownCounter.value > 1)
        countdownCounter--;
      else {
        countdownCounter.value--;
        setCounter();
        countdownTimer.cancel();
      }
    });
  }

  setCounter() async {
    counter.value = 15;

    timer = Timer.periodic(1.seconds, (timer) async {
      if (counter.value == 6 && isSoundOn.value) {
        audioPlayer = await audioCache.play('sounds/fiveSeconds.mp3');
      }

      if (counter.value > 0) {
        if (!isSoundOn.value) audioPlayer?.pause();
        counter.value--;
      } else {
        isTime.value = true;
        timer.cancel();
        await Get.defaultDialog(
          backgroundColor: Colors.red,
          barrierDismissible: false,
          title: 'Game Over',
          titleStyle: TextStyle(color: Colors.white),
          content: Column(
            children: [
              currentIndex.value > 1
                  ? Text(
                      'You answered  ${currentIndex.value}  questions right.',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'You answered  ${currentIndex.value}  question right.',
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
                      firstCountdown();
                      fetchData();
                      if (isDialogOpen.value) {
                        Get.back();
                        Get.back();
                        isDialogOpen.value = false;
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
      }
    });
  }

  shufleWrongAnswers() {
    falseAnswersList.shuffle();
  }

  fiftyJokerVariantCheck(String answer) {
    if (isFiftyJokerPressed.value) {
      if (answer == falseAnswersList[0] || answer == falseAnswersList[1]) {
        // print('joker $answer');

        return true;
      }

      return false;
    }
    return false;
  }
}
