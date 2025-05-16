import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';

class EditParticipantModal {
  static Future<void> show(BuildContext context, Participant participant) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ParticipantFormWidget(initialData: participant),
        );
      },
    );
  }
}

class ParticipantFormWidget extends StatefulWidget {
  final Participant initialData;

  const ParticipantFormWidget({super.key, required this.initialData});

  @override
  State<ParticipantFormWidget> createState() => _ParticipantFormWidgetState();
}

class _ParticipantFormWidgetState extends State<ParticipantFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bibController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bibController.text = widget.initialData.bib.toString();
    _nameController.text = widget.initialData.name;
  }

  @override
  void dispose() {
    _bibController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Participant',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bibController,
                decoration: const InputDecoration(
                  labelText: 'BIB Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter BIB number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter participant name' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      color: Colors.grey.shade300,
                      textColor: AppColors.text,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.gap),
                  Expanded(
                    child: AppButton(
                      label: 'Save Changes',
                      color: AppColors.primary,
                      textColor: AppColors.text,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final bib = int.tryParse(_bibController.text) ?? 0;
                          final name = _nameController.text;
                          provider.updateParticipant(
                              widget.initialData.id, bib, name);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
