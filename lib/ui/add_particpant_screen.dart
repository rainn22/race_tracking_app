import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant_entry.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant/entry_list.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';
import 'package:race_tracking_app/utils/widgets/loading.dart';

class BulkAddParticipantsScreen extends StatefulWidget {
  const BulkAddParticipantsScreen({super.key});

  @override
  State<BulkAddParticipantsScreen> createState() =>
      _BulkAddParticipantsScreenState();
}

class _BulkAddParticipantsScreenState extends State<BulkAddParticipantsScreen> {
  final List<ParticipantEntry> _entries = List.generate(
    3,
    (_) => ParticipantEntry(
      bibController: TextEditingController(),
      nameController: TextEditingController(),
    ),
  );

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (var entry in _entries) {
      entry.bibController.addListener(_validateAllEntries);
      entry.nameController.addListener(_validateAllEntries);
    }
  }

  @override
  void dispose() {
    for (var entry in _entries) {
      entry.bibController.dispose();
      entry.nameController.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    final entry = ParticipantEntry(
      bibController: TextEditingController(),
      nameController: TextEditingController(),
    );
    entry.bibController.addListener(_validateAllEntries);
    entry.nameController.addListener(_validateAllEntries);

    setState(() {
      _entries.add(entry);
    });
  }

  void _validateAllEntries() {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);
    final existingBibs = provider.getAllBibs();
    final inputBibs = <int, int>{};

    for (int i = 0; i < _entries.length; i++) {
      final bibText = _entries[i].bibController.text.trim();
      if (bibText.isNotEmpty) {
        final bibNumber = int.tryParse(bibText);
        if (bibNumber != null) {
          if (inputBibs.containsKey(bibNumber)) {
            inputBibs[bibNumber] = -1;
          } else {
            inputBibs[bibNumber] = i;
          }
        }
      }
    }

    bool changed = false;

    for (int i = 0; i < _entries.length; i++) {
      final entry = _entries[i];
      final bibText = entry.bibController.text.trim();
      final nameText = entry.nameController.text.trim();

      String? bibError;
      String? nameError;

      if (bibText.isEmpty && nameText.isNotEmpty) {
        bibError = 'BIB required';
      } else if (bibText.isNotEmpty && nameText.isEmpty) {
        nameError = 'Name required';
      }

      if (bibText.isNotEmpty) {
        final bibNumber = int.tryParse(bibText);
        if (bibNumber == null) {
          bibError = 'BIB must be a valid number';
        } else if (bibNumber <= 0) {
          bibError = 'BIB must be greater than 0';
        } else if (existingBibs.contains(bibNumber)) {
          bibError = 'This BIB already exists';
        } else if (inputBibs[bibNumber] == -1) {
          bibError = 'Duplicate BIB in this form';
        }
      }

      if (entry.bibError != bibError) {
        entry.bibError = bibError;
        changed = true;
      }
      if (entry.nameError != nameError) {
        entry.nameError = nameError;
        changed = true;
      }
    }

    if (changed) {
      setState(() {});
    }
  }

  bool get _hasErrors {
    for (var entry in _entries) {
      if (entry.bibError != null || entry.nameError != null) {
        return true;
      }
      final bibFilled = entry.bibController.text.trim().isNotEmpty;
      final nameFilled = entry.nameController.text.trim().isNotEmpty;
      if ((bibFilled && !nameFilled) || (!bibFilled && nameFilled)) {
        return true;
      }
    }
    return false;
  }

  bool get _hasValidEntries {
    return _entries.any((entry) {
      return entry.bibController.text.trim().isNotEmpty &&
          entry.nameController.text.trim().isNotEmpty &&
          entry.bibError == null &&
          entry.nameError == null;
    });
  }

  Future<void> _submitEntries() async {
    if (_hasErrors) {
      await _showAlertDialog(
        title: 'Unable to Submit',
        message: 'Please complete all information before submitting.',
      );
      return;
    }

    if (!_hasValidEntries) {
      await _showAlertDialog(
        title: 'No Valid Entries',
        message: 'Please add at least one complete entry.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = Provider.of<ParticipantProvider>(context, listen: false);
    final validEntries = _entries.where((entry) {
      return entry.bibController.text.trim().isNotEmpty &&
          entry.nameController.text.trim().isNotEmpty &&
          entry.bibError == null &&
          entry.nameError == null;
    }).toList();

    for (var entry in validEntries) {
      final bib = int.parse(entry.bibController.text.trim());
      final name = entry.nameController.text.trim();
      await provider.addParticipant(bib, name);
    }

    setState(() => _isSubmitting = false);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showAlertDialog({required String title, required String message}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Participants')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.padding),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(child: Text('#BIB', style: AppTextStyles.textLg)),
                    SizedBox(width: AppSpacing.gap),
                    Expanded(child: Text('Name', style: AppTextStyles.textLg)),
                  ],
                ),
                const SizedBox(height: AppSpacing.gap),
                Expanded(
                  child: ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      return ParticipantEntryRow(entry: _entries[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.gap),
                  child: AppButton(
                    label: 'Add Row',
                    color: AppColors.secondary,
                    textColor: AppColors.text,
                    icon: Icons.add,
                    onTap: _addRow,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        color: AppColors.secondary,
                        textColor: AppColors.text,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.gap),
                    Expanded(
                      child: AppButton(
                        label: _isSubmitting ? 'Submitting...' : 'Submit',
                        color: AppColors.primary,
                        textColor: AppColors.text,
                        onTap: _isSubmitting ? () {} : _submitEntries,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          LoadingUI(isLoading: _isSubmitting),
        ],
      ),
    );
  }
}
