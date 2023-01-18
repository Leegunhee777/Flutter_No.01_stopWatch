import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const OneMinutes = 60;
  int totalSeconds = OneMinutes;
  bool isRunning = false;

  //지정된 시간이 다 지나면 pomodoros가 1증가하며 시간이 다시 reset된다.
  int totalPomodoros = 0;

  // Timer는 dart의 표준 라이브러리에 포함되어 있다.
  late Timer timer;

  //periodic 함수의 콜백은 인자로 Timer를 받아줘야함
  void onTick(Timer timer) {
    //지정된시간이 모두 소진되었을때 처리로직
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = OneMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    //periodic 은 일정시간 주기로 콜백함수를 실행시킬수있는 setInverval같은 함수임
    timer = Timer.periodic(const Duration(seconds: 1), onTick);

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    //엄청 유용한 class인 Duration 클래스!!!
    //초단위를 분다위로 바꾸기!!

    var duration = Duration(seconds: seconds);
    return (duration.toString().split('.').first.substring(2, 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          //Flexible을 사용해서 높이 200, 너비 100 딱 정해진게 아니라
          //UI비율에 기반해서 더 유연하게 만들수 있게 해준다.
          Flexible(
              //flex default: 1이다.
              flex: 1,
              child: Container(
                //
                alignment: Alignment.bottomCenter,
                child: Text(
                  format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          Flexible(
              flex: 3,
              child: Center(
                  child: IconButton(
                onPressed: isRunning ? onPausePressed : onStartPressed,
                iconSize: 150,
                color: Theme.of(context).cardColor,
                icon: Icon(isRunning
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_outline),
              ))),
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  //Expanded를 사용해서 영역을 꽉 차게 확장해 줌
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          //BorderRadius.circular(50)로 하단이 이상하게 보일수있음
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pomodors',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                          ),
                          Text(
                            '$totalPomodoros',
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
