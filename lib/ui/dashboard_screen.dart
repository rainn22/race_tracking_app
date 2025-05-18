import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  DateTime? _parse(String? s) => s != null ? DateTime.tryParse(s) : null;

  Duration? _dur(DateTime? a, DateTime? b) =>
      (a != null && b != null) ? b.difference(a) : null;

  String _fmt(Duration? d) =>
      d == null ? '-' : d.toString().split('.').first.padLeft(8, '0');

  @override
  Widget build(BuildContext context) {
    final participants =
        context.watch<ParticipantProvider>().participantState?.data ?? [];
    final seg = context.watch<SegmentTimeProvider>();
    final raceStart = context.watch<RaceStageProvider>().raceStage?.startTime;

    if (raceStart == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final resultRows = participants.map((p) {
      final swimEnd = _parse(seg.getEndTime(p.id, Segment.swimming.label));
      final cycleEnd = _parse(seg.getEndTime(p.id, Segment.cycling.label));
      final runEnd = _parse(seg.getEndTime(p.id, Segment.running.label));

      final swim = _dur(raceStart, swimEnd);
      final cycle = _dur(swimEnd, cycleEnd);
      final run = _dur(cycleEnd, runEnd);

      final total = (swim != null && cycle != null && run != null)
          ? swim + cycle + run
          : null;

      return _ResultRow(
        bib: p.bib.toString(),
        name: p.name,
        swim: swim,
        cycle: cycle,
        run: run,
        total: total,
      );
    }).toList();

    // Sort rows based on total time (nulls go last)
    resultRows.sort((a, b) {
      if (a.total == null && b.total == null) return 0;
      if (a.total == null) return 1;
      if (b.total == null) return -1;
      return a.total!.compareTo(b.total!);
    });

    // Build table rows with rank
    int rank = 1;
    final tableRows = <TableRow>[
      _headerRow(),
      for (final r in resultRows)
        _dataRow(
          rankText: r.total == null ? '-' : (rank++).toString(),
          r: r,
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 800,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.padding),
            children: [
              Table(
                border: const TableBorder.symmetric(
                    inside: BorderSide(color: AppColors.darkGrey)),
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FixedColumnWidth(60),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(90),
                  4: FixedColumnWidth(90),
                  5: FixedColumnWidth(90),
                  6: FixedColumnWidth(100),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: tableRows,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Table Header Row
  TableRow _headerRow() => const TableRow(
        decoration: BoxDecoration(color: AppColors.secondary),
        children: [
          _Header('RANK'),
          _Header('BIB'),
          _Header('NAME'),
          _Header('SWIM'),
          _Header('CYCLE'),
          _Header('RUN'),
          _Header('TOTAL'),
        ],
      );

  // Data Row for Each Participant
  TableRow _dataRow({required String rankText, required _ResultRow r}) =>
      TableRow(children: [
        _cell(rankText),
        _cell(r.bib),
        _cell(r.name),
        _cell(_fmt(r.swim)),
        _cell(_fmt(r.cycle)),
        _cell(_fmt(r.run)),
        _cell(_fmt(r.total)),
      ]);

  // Cell Builder
  static Widget _cell(String text) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: AppTextStyles.textMd.copyWith(fontWeight: FontWeight.bold),
        ),
      );
}

// Header Cell Widget
class _Header extends StatelessWidget {
  final String label;
  const _Header(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: AppTextStyles.textSm.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
      );
}

// Internal Row Model
class _ResultRow {
  final String bib;
  final String name;
  final Duration? swim, cycle, run, total;
  _ResultRow({
    required this.bib,
    required this.name,
    this.swim,
    this.cycle,
    this.run,
    this.total,
  });
}
