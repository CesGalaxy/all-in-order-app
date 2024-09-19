import 'package:all_in_order/db/models/subject.dart';
import 'package:flutter/material.dart';

class SubjectHero extends StatelessWidget {
  final Subject subject;

  const SubjectHero({super.key, required this.subject});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 120,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            ClipRect(
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                minWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
                child: Image.network(
                    'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_1.png'),
              ),
            ),
            // Dark transparent gradient background
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: <Color>[Color(0x10000000), Color(0x80000000)],
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
        ),
      );
}
