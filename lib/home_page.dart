import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/list_tiles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List habitList = [
    ['Exercise', false, 0, 1],
    ['Reading', false, 0, 1],
    ['Meditation', false, 0, 1],
    ['Coding', false, 0, 1],
    ['Playing Guitar', false, 0, 1],
  ];

  int selectedValue = 0;
  late SharedPreferences preferences;
  TextEditingController habitControl = TextEditingController();

  void habitOnClick(int index) {
    var startTime = DateTime.now();
    var elapsedTime = habitList[index][2];

    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              3600 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void timerOnClick(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Set Time for',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '${habitList[index][0]}',
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  onTimerDurationChanged: (value) {
                    setState(() {
                      habitList[index][3] = value.inMinutes;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  Future initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                      height: 220,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Add Good Habit',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: habitControl,
                                decoration: const InputDecoration(
                                    hintText: 'Enter Habit Name',
                                    labelText: 'Enter Habit Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              child: const Text('Done'),
                              onPressed: () {
                                setState(() {
                                  habitList
                                      .add([habitControl.text, false, 0, 1]);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
        backgroundColor: Colors.grey[900],
        title: const Text('Consistency is Key'),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: (context, index) => HabitTile(
          habitName: habitList[index][0],
          currentTime: habitList[index][2],
          goalTime: habitList[index][3],
          onDeleteTap: () {
            setState(() {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Do you Really Want To Delete'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          setState(() {
                            if (habitControl.text != '') {
                              habitList.removeAt(index);
                            }
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            });
          },
          onPlayTap: () {
            habitOnClick(index);
          },
          onTimeTap: () {
            timerOnClick(index);
          },
          habitStarted: habitList[index][1],
        ),
      ),
    );
  }
}
