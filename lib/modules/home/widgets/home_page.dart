import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/course.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/modules/subject/widgets/providers.dart';
import 'package:all_in_order/supabase.dart';
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

  TextEditingController _newCourseOrSubjectNameController =
      TextEditingController();
  TextEditingController _newCourseOrSubjectDescriptionController =
      TextEditingController();

  static const subjectColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightGreen,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    _newCourseOrSubjectNameController = TextEditingController();
    _newCourseOrSubjectDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newCourseOrSubjectNameController.dispose();
    _newCourseOrSubjectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: CacheHandler(
        collection: Provider.of<CachedCollection<CourseWithSubjects>>(context),
        errorAction: (_) {},
        emptyActionLabel: "Create a new course",
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
        label: const Text("New course"),
      ),
    );
  }

  Widget _courseTile(CourseWithSubjects course) => ExpansionTile(
        shape: const Border(),
        initiallyExpanded: true,
        title: Text(course.name),
        subtitle: course.description != null ? Text(course.description!) : null,
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showSubjectCreationModal(course.id),
        ),
        children: [_courseSubjects(course)],
      );

  Widget _courseSubjects(CourseWithSubjects course) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 128),
        child: course.subjects.isEmpty
            ? Center(
                child: FilledButton(
                  onPressed: () => _showSubjectCreationModal(course.id),
                  child: const Text("Create a new subject"),
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

  void _showCourseCreationModal() => showModalBottomSheet<bool>(
        context: context,
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Create a new course",
                style: Theme.of(context).textTheme.headlineMedium),
            TextField(
              controller: _newCourseOrSubjectNameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _newCourseOrSubjectDescriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: _submitCourseCreation,
                child: const Text("Create Course"))
          ],
        ),
      );

  void _submitCourseCreation() async {
    try {
      await supabase.from("courses").insert({
        "name": _newCourseOrSubjectNameController.text,
        "description": _newCourseOrSubjectDescriptionController.text,
      });

      if (mounted) {
        Navigator.pop(context);
        setState(() {
          Provider.of<CachedCollection<CourseWithSubjects>>(context,
                  listen: false)
              .refresh(force: true);
          _newCourseOrSubjectNameController = TextEditingController();
          _newCourseOrSubjectDescriptionController = TextEditingController();
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
          ),
        );
      }
    }
  }

  void _showSubjectCreationModal(int courseId) => showModalBottomSheet<bool>(
        context: context,
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Create a new subject",
                style: Theme.of(context).textTheme.headlineMedium),
            TextField(
              controller: _newCourseOrSubjectNameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _newCourseOrSubjectDescriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              children: subjectColors
                  .map((color) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () => _submitSubjectCreation(courseId, color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      );

  void _submitSubjectCreation(int courseId, Color color) async {
    try {
      await supabase.from("subjects").insert({
        "course_id": courseId,
        "name": _newCourseOrSubjectNameController.text,
        "description": _newCourseOrSubjectDescriptionController.text,
        "color": color.value,
      });

      if (mounted) {
        Navigator.pop(context);

        setState(() {
          Provider.of<CachedCollection<CourseWithSubjects>>(context,
                  listen: false)
              .refresh(force: true);
          _newCourseOrSubjectNameController = TextEditingController();
          _newCourseOrSubjectDescriptionController = TextEditingController();
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
          ),
        );
      }
    }
  }
}
