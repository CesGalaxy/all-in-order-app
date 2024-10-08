import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/subject/agenda/navigation.dart';
import 'package:all_in_order/modules/subject/calendar/general.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectCalendarNavigation extends StatefulWidget {
  const SubjectCalendarNavigation({super.key, required this.subjectId});

  final int subjectId;

  @override
  State<SubjectCalendarNavigation> createState() =>
      _SubjectCalendarNavigationState();
}

class _SubjectCalendarNavigationState extends State<SubjectCalendarNavigation> {
  final GlobalKey<ExpandableBottomSheetState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    return CacheHandler(
      collection: Provider.of<CachedCollection<SubjectEvent>>(context),
      errorAction: (_) {},
      emptyActionLabel: S.of(context).createEvent,
      emptyAction: () {},
      builder: (context, events, _) => Scaffold(
        body: ExpandableBottomSheet(
          key: _key,
          onIsExtendedCallback: () => setState(() {}),
          onIsContractedCallback: () => setState(() {}),
          background: SubjectCalendarGeneralView(
            subjectId: widget.subjectId,
            events: events,
          ),
          persistentHeader: SizedBox(
            height: kToolbarHeight + 1,
            child: Column(children: [
              const Divider(height: 1, thickness: 1),
              Material(
                child: InkWell(
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(S.of(context).agenda),
                    centerTitle: true,
                    leading: AnimatedRotation(
                      turns: _key.currentState?.expansionStatus ==
                              ExpansionStatus.expanded
                          ? 0.5
                          : 0,
                      duration: const Duration(milliseconds: 100),
                      child: const Icon(Icons.keyboard_double_arrow_up),
                    ),
                  ),
                  onTap: () => setState(() {
                    if (_key.currentState?.expansionStatus ==
                        ExpansionStatus.contracted) {
                      _key.currentState!.expand();
                    } else {
                      _key.currentState!.contract();
                    }
                  }),
                ),
              ),
            ]),
          ),
          expandableContent: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight * 4,
            child: const SubjectAgendaNavigation(),
          ),
        ),
      ),
    );
  }
}
