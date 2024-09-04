import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/course.dart';
import 'package:all_in_order/modules/subject/widgets/providers.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

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

  Color _newSubjectColor = Colors.blue;

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

  // TODO: Make this a provider
  Future<List<Course>?> _coursesFetch = Course.fetchAll();

  @override
  void initState() {
    _coursesFetch = Course.fetchAll();
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
    width = MediaQuery
        .sizeOf(context)
        .width;
    height = MediaQuery
        .sizeOf(context)
        .height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<List<Course>?>(
              future: _coursesFetch,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    heightFactor: 2,
                    child: FilledButton(
                        onPressed: _showCourseCreationModal,
                        child: const Text("Create a new course")),
                  );
                }

                final courses = snapshot.data as List<Course>;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: courses.length,
                  itemBuilder: (context, index) =>
                      ExpansionTile(
                        shape: const Border(),
                        initiallyExpanded: true,
                        title: Text(courses[index].name),
                        subtitle: courses[index].description != null
                            ? Text(courses[index].description!)
                            : null,
                        children: [_courseSubjects(context, courses[index])],
                      ),
                );
              })
        ],
      ),
    );
  }

  Widget _courseSubjects(BuildContext context, Course course) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 128),
      child: course.subjects!.isEmpty
          ? Center(
        child: FilledButton(
          onPressed: () => _showSubjectCreationModal(course.id),
          child: const Text("Create a new subject"),
        ),
      )
          : CarouselView.weighted(
        // controller: _,
        itemSnapping: true,
        flexWeights: const <int>[1, 7, 1],
        children:
        course.subjects!.map(_spaceProjectHeroLayoutCard).toList(),
        onTap: (index) =>
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SubjectProviders(subject: course.subjects![index]))),
      ),
    );
  }

  Widget _spaceProjectHeroLayoutCard(Subject subject) {
    return Stack(
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
                style: Theme
                    .of(context)
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                )
            ],
          ),
        ),
      ],
    );
  }

  void _showCourseCreationModal() {
    _newCourseOrSubjectNameController = TextEditingController();
    _newCourseOrSubjectDescriptionController = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Create a new course",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: _newCourseOrSubjectNameController,
                decoration: const InputDecoration(
                    labelText: "Course Name", hintText: "Enter course name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newCourseOrSubjectDescriptionController,
                decoration: const InputDecoration(
                    labelText: "Course Description",
                    hintText: "Enter course description"),
              ),
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: () => _submitCourseCreation(context),
                  child: const Text("Create Course"))
            ],
          );
        });
  }

  _submitCourseCreation(BuildContext context) async {
    try {
      await supabase.from("courses").insert({
        "name": _newCourseOrSubjectNameController.text,
        "description": _newCourseOrSubjectDescriptionController.text,
      });

      if (context.mounted) {
        Navigator.pop(context);
        setState(() {
          _coursesFetch = Course.fetchAll();
        });
      }
    } catch (e) {
      print("Error: $e");

      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text("An error occurred: $e"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              );
            });
      }
    }
  }

  void _showSubjectCreationModal(int courseId) {
    _newCourseOrSubjectNameController = TextEditingController();
    _newCourseOrSubjectDescriptionController = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Create a new subject",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: _newCourseOrSubjectNameController,
                decoration: const InputDecoration(
                    labelText: "Subject Name", hintText: "Enter subject name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newCourseOrSubjectDescriptionController,
                decoration: const InputDecoration(
                    labelText: "Subject Description",
                    hintText: "Enter subject description"),
              ),
              const SizedBox(height: 16),
              Text("Select the color of the subject",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                children: subjectColors
                    .map((color) =>
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          _newSubjectColor = color;
                          if (context.mounted) {
                            _submitSubjectCreation(context, courseId);
                          }
                        },
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
          );
        });
  }

  Future _submitSubjectCreation(BuildContext context, int courseId) async {
    try {
      await supabase.from("subjects").insert({
        "course_id": courseId,
        "name": _newCourseOrSubjectNameController.text,
        "description": _newCourseOrSubjectDescriptionController.text,
        "color": _newSubjectColor.value,
      });

      if (context.mounted) {
        Navigator.pop(context);
        setState(() {
          _coursesFetch = Course.fetchAll();
        });
      }
    } catch (e) {
      print("Error: $e");

      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text("An error occurred: $e"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              );
            });
      }
    }
  }
}
