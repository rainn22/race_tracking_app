import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';

class ParticipantForm extends StatefulWidget {
  final Participant? participant;

  const ParticipantForm({super.key, this.participant});

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bibController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.participant != null) {
      _bibController.text = widget.participant!.bib.toString();
      _nameController.text = widget.participant!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);

    return AlertDialog(
      title: Text(widget.participant == null ? 'Add Participant' : 'Edit Participant'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _bibController,
              decoration: const InputDecoration(labelText: 'BIB Number'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter BIB number' : null,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => value!.isEmpty ? 'Enter participant name' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final bib = int.tryParse(_bibController.text) ?? 0;
              final name = _nameController.text;

              if (widget.participant == null) {
                provider.addParticipant(bib, name);
              } else {
                provider.updateParticipant(widget.participant!.id, bib, name);
              }

              Navigator.of(context).pop();
            }
          },
          child: Text(widget.participant == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}

void showParticipantForm(BuildContext context, {Participant? participant}) {
  showDialog(
    context: context,
    builder: (context) => ParticipantForm(participant: participant),
  );
}
