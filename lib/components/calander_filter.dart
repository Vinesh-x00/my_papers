import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_papers/models/note_database.dart';
import 'package:my_papers/models/utils.dart';

enum SwitchingDirection { left, right }

class CalanderFilter extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const CalanderFilter(
      {super.key, required this.startDate, required this.endDate});

  @override
  State<CalanderFilter> createState() => _CalanderFilterState();
}

class _CalanderFilterState extends State<CalanderFilter> {

  void changeDate(SwitchingDirection dir, NoteDatabase db)  {
    late DateTime switechedDate;
    if (dir == SwitchingDirection.left) {
      switechedDate = widget.startDate.subtract(Duration(days: 2));
    } else {
      switechedDate = widget.endDate.add(Duration(days: 2));
    }
    db.fetchNote(fdate: switechedDate);
  }

  void selectDate(NoteDatabase db) async {
    final currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1, 12, 31),
    );
    picked ??= currentDate;
    db.fetchNote(fdate: picked);
  }

  @override
  Widget build(BuildContext context) {
    final notedb = context.watch<NoteDatabase>();

    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => changeDate(SwitchingDirection.left, notedb),
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => selectDate(notedb),
                child: Text(
                    "${formatDate(date: widget.startDate, withyear: false)} - ${formatDate(date: widget.endDate, withyear: false)}"),
              ),
            ),
          ),
          IconButton(
            onPressed: () => changeDate(SwitchingDirection.right, notedb),
            icon: Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
