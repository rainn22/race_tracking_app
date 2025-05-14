import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/utils/widgets/participant_form.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.hasData) {
      final participants = provider.participantState!.data!;
      if (participants.isEmpty) {
        return const Center(child: Text("No participants yet"));
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final participant = participants[index];

            return Dismissible(
              key: Key(participant.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                provider.deleteParticipant(participant.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${participant.name} deleted')),
                );
              },
              child: ListTile(
                title: Text(participant.name),
                subtitle: Text("BIB: ${participant.bib}"),
                trailing: const Icon(Icons.edit, color: Colors.blue),
                onTap: () => showParticipantForm(context, participant: participant),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(child: Text("Failed to load data"));
    }
  }
}
