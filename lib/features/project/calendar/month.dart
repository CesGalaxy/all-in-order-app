import 'package:flutter/material.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({super.key});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  ScrollController _scrollController = ScrollController();

  bool _showWeekend = false;

  @override
  Widget build(BuildContext context) {
    final int daysInWeek = _showWeekend ? 7 : 5;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToMonth(DateTime.now().month, animate: false);
    });

    return Column(
      children: [
        Container(
          child: Row(
            children: [
              const Text('Show weekend'),
              Switch(
                value: _showWeekend,
                onChanged: (bool value) {
                  setState(() {
                    _showWeekend = value;
                  });
                },
              ),
              FilledButton(
                  onPressed: () => _scrollToWeek(2),
                  child: const Text('Scroll')),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 12,
            itemBuilder: (BuildContext context, int monthIndex) {
              final DateTime date =
                  DateTime(DateTime.now().year, monthIndex + 1);
              final List<List<num>> month = _getMonth(date);

              return Column(
                children: [
                  Text(
                    date.month.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: daysInWeek,
                      ),
                      itemCount: month.length * daysInWeek,
                      itemBuilder: (BuildContext context, int dayIndex) {
                        final int i = dayIndex ~/ daysInWeek;
                        final int j = dayIndex % daysInWeek;
                        final List<num> week = month[i];
                        final num day = week[j];
                        return Center(
                          child: Text(
                            day == 0 ? '' : day.toString(),
                            style: TextStyle(
                              color:
                                  day == 0 ? Colors.transparent : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  void _scrollToMonth(int month, {bool animate = true}) {
    final double cellWidth =
        MediaQuery.of(context).size.width / (_showWeekend ? 7 : 5);
    final double monthGridHeight = 6 * cellWidth;
    const double monthHeaderHeight = 34;
    final double monthHeight = monthGridHeight + monthHeaderHeight;
    final double offset = (month - 1) * monthHeight;

    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  void _scrollToWeek(int week, {bool animate = true}) {
    final double cellWidth =
        MediaQuery.of(context).size.width / (_showWeekend ? 7 : 5);

    final double monthGridHeight = 6 * cellWidth;
    const double monthHeaderHeight = 34;
    final double monthHeight = monthGridHeight + monthHeaderHeight;

    final int month = (week ~/ 6);

    final double offset =
        (monthHeight * month) + ((week % 6) * cellWidth) + (cellWidth * month);

    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  List<List<num>> _getMonth(DateTime date) {
    final List<List<num>> month = [];
    final int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final int firstDay = DateTime(date.year, date.month, 1).weekday;

    int day = 1;

    for (int i = 0; i < 6; i++) {
      final List<num> week = [];

      for (int j = 0; j < 7; j++) {
        if (i == 0 && j < firstDay - 1) {
          week.add(0);
        } else if (day > daysInMonth) {
          week.add(0);
        } else {
          week.add(day);
          day++;
        }
      }

      month.add(week);
    }

    return month;
  }
}
