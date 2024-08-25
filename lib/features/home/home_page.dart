import 'package:all_in_order/features/project/providers.dart';
import 'package:flutter/material.dart';

import '../../db/models/Space.dart';
import '../../db/models/project.dart';

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
        title: const Text("My Spaces"),
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
          FutureBuilder<List<Space>?>(
              future: Space.fetchAll(),
              builder: (context, snapshot) {
                print(snapshot.data);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (snapshot.hasData) {
                  final spaces = snapshot.data as List<Space>;

                  return Column(
                    children: spaces
                        .map((e) => ExpansionTile(
                              shape: const Border(),
                              initiallyExpanded: true,
                              title: Text(e.name),
                              subtitle: Text(e.description),
                              children: [_spaceProjects(context, e)],
                            ))
                        .toList(),
                  );
                }

                return const Text("No data");
              })
        ],
      ),
    );
  }

  Widget _spaceProjects(BuildContext context, Space space) {
    return FutureBuilder<List<Project>?>(
      future: Project.fetchBySpace(space.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.hasData) {
          final projects = snapshot.data as List<Project>;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 128),
            child: CarouselView.weighted(
              // controller: _,
              itemSnapping: true,
              flexWeights: const <int>[1, 7, 1],
              children: projects.map(_spaceProjectHeroLayoutCard).toList(),
              onTap: (index) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProjectProviders(project: projects[index]))),
            ),
          );
        }

        return const Text("No data");
      },
    );
  }

  Widget _spaceProjectHeroLayoutCard(Project project) {
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
                project.name,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                project.resume,
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
  }
}
