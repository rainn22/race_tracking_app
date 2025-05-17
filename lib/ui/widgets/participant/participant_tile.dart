import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/divider.dart';
import 'package:race_tracking_app/ui/widgets/participant/participant_form.dart'; // For EditParticipantModal

class ParticipantTile extends StatelessWidget {
  final Participant participant;

  const ParticipantTile({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);

    return Dismissible(
      key: Key(participant.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      onDismissed: (_) {
        provider.deleteParticipant(participant.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${participant.name} deleted')),
        );
      },
      child: Column(
        children: [
          ListTile(
            tileColor: AppColors.bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                participant.bib.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              participant.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'BIB: #${participant.bib}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            onTap: () async {
              await EditParticipantModal.show(context, participant);
            },
          ),
          const AppDivider()
        ],
      ),
    );
  }
}
