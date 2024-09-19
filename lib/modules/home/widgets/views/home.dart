import 'package:all_in_order/db/models/course.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/course/widgets/modals/create.dart';
import 'package:all_in_order/modules/course/widgets/modals/edit.dart';
import 'package:all_in_order/modules/course/widgets/views/members_manager.dart';
import 'package:all_in_order/modules/subject/widgets/modals/create.dart';
import 'package:all_in_order/modules/subject/widgets/providers.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo/NameCol.png"),
        bottom: AppBar(
          centerTitle: true,
          title: Text(S.of(context).myCourses),
          leading: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: CacheHandler(
        collection: Provider.of<CachedCollection<CourseWithSubjects>>(context),
        errorAction: (_) {},
        emptyActionLabel: S.of(context).createANewCourse,
        emptyAction: _showCourseCreationModal,
        builder: (context, courses, _) => ListView.builder(
          shrinkWrap: true,
          itemCount: courses.length,
          itemBuilder: (context, index) => _courseTile(courses[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCourseCreationModal,
        icon: const Icon(Icons.create_new_folder),
        label: Text(S.of(context).newCourse),
      ),
    );
  }

  Widget _courseTile(CourseWithSubjects course) => ExpansionTile(
        shape: const Border(),
        initiallyExpanded: true,
        title: Text(course.name),
        subtitle: course.description != null ? Text(course.description!) : null,
        leading: PopupMenuButton(
          icon: const Icon(Icons.menu),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              onTap: () => _showSubjectCreationModal(course.id),
              child: const ListTile(
                leading: Icon(Icons.add),
                title: Text("Create Subject"),
              ),
            ),
            PopupMenuItem(
              onTap: () => _showCourseEditionModal(course),
              child: const ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit"),
              ),
            ),
            PopupMenuItem(
              onTap: () => _showCourseMembersManager(course.id),
              child: const ListTile(
                leading: Icon(Icons.people),
                title: Text("Members"),
              ),
            ),
            PopupMenuItem(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
              ),
            ),
          ],
        ),
        children: [_courseSubjects(course)],
      );

  Widget _courseSubjects(CourseWithSubjects course) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 128),
        child: course.subjects.isEmpty
            ? Center(
                child: FilledButton(
                  onPressed: () => _showSubjectCreationModal(course.id),
                  child: Text(S.of(context).createANewSubject),
                ),
              )
            : CarouselView.weighted(
                itemSnapping: true,
                flexWeights: const <int>[1, 7, 1],
                children: course.subjects.map(_courseSubjectCard).toList(),
                onTap: (index) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubjectProviders(subject: course.subjects[index]),
                  ),
                ),
              ),
      );

  Widget _courseSubjectCard(Subject subject) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          ClipRect(
            child: OverflowBox(
              maxWidth: width * 7 / 8,
              minWidth: width * 7 / 8,
              child: const Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_1.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  subject.name,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                if (subject.description != null) const SizedBox(height: 10),
                if (subject.description != null)
                  Text(
                    subject.description!,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  )
              ],
            ),
          ),
        ],
      );

  void _showCourseCreationModal() async {
    if (await showCourseCreationModal(context) && mounted) {
      Provider.of<CachedCollection<CourseWithSubjects>>(context, listen: false)
          .refresh(force: true);
    }
  }

  void _showCourseEditionModal(Course course) async {
    if (await showCourseEditModal(context, course) && mounted) {
      Provider.of<CachedCollection<CourseWithSubjects>>(context, listen: false)
          .refresh(force: true);
    }
  }

  void _showCourseMembersManager(int courseId) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseMembersManager(courseId: courseId),
      ));

  void _showSubjectCreationModal(int courseId) async {
    if (await showSubjectCreationModal(context, courseId) && mounted) {
      Provider.of<CachedCollection<CourseWithSubjects>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
