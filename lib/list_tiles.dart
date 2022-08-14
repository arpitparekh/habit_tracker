import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onPlayTap;
  final VoidCallback onTimeTap;
  final VoidCallback onDeleteTap;
  final int currentTime;
  final int goalTime;
  final bool habitStarted;

  const HabitTile(
      {Key? key,
      required this.habitName,
      required this.onPlayTap,
      required this.onTimeTap,
      required this.currentTime,
      required this.goalTime,
      required this.habitStarted,
      required this.onDeleteTap})
      : super(key: key);

  String convertSec(int seconds) {
    String secs = (seconds % 60).toString();
    String mins = (seconds / 60).toStringAsFixed(5);

    if (secs.length == 1) {
      secs = '0$secs';
    }

    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }

    return '$mins : $secs';
  }

  double percentageCount() {
    return (currentTime / (goalTime * 60));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onPlayTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        Center(
                            child: habitStarted
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow)),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 30,
                            percent:
                                percentageCount() < 1 ? percentageCount() : 1,
                            progressColor: percentageCount() > 0.5
                                ? (percentageCount() > 0.75
                                    ? Colors.green
                                    : Colors.orange)
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                        '${convertSec(currentTime)} / $goalTime = ${(percentageCount() * 100).toStringAsFixed(0)} %'),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: onTimeTap,
                  child: const Icon(
                    Icons.timer,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: onDeleteTap,
                  child: const Icon(
                    Icons.restore_from_trash_sharp,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
