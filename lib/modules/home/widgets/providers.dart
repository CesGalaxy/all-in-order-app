import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/course.dart';
import 'package:all_in_order/modules/home/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProviders extends StatelessWidget {
  final CachedCollection<CourseWithSubjects> _courses =
      CachedCollection<CourseWithSubjects>(
    fetch: CourseWithSubjects.fetchAll,
    cacheDuration: const Duration(minutes: 5),
  );

  HomeProviders({super.key});

  @override
  Widget build(BuildContext context) {
    _courses.refresh();

    return ChangeNotifierProvider.value(
      value: _courses,
      child: const HomeNavigation(),
    );
  }
}
