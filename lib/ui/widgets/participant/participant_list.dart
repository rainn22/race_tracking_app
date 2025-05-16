import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant/participant_tile.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (!provider.hasData) {
      return const Center(child: Text("Failed to load data"));
    }

    final participants = provider.participantState!.data!;

    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return ParticipantTile(participant: participant);
      },
    );
  }
}