import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';

class BulkAddParticipantsScreen extends StatefulWidget {
  const BulkAddParticipantsScreen({super.key});

  @override
  State<BulkAddParticipantsScreen> createState() => _BulkAddParticipantsScreenState();
}

class _BulkAddParticipantsScreenState extends State<BulkAddParticipantsScreen> {
  final List<ParticipantEntry> _entries = [
    ParticipantEntry(bibController: TextEditingController(), nameController: TextEditingController()),
    ParticipantEntry(bibController: TextEditingController(), nameController: TextEditingController()),
    ParticipantEntry(bibController: TextEditingController(), nameController: TextEditingController()),
  ];

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    for (var entry in _entries) {
      entry.bibController.dispose();
      entry.nameController.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _entries.add(
        ParticipantEntry(
          bibController: TextEditingController(),
          nameController: TextEditingController(),
        ),
      );
    });
  }

  void _submitEntries() {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);
    
    // Filter out empty entries
    final validEntries = _entries.where((entry) {
      final hasBib = entry.bibController.text.trim().isNotEmpty;
      final hasName = entry.nameController.text.trim().isNotEmpty;
      return hasBib && hasName;
    }).toList();
    
    // Add all valid participants
    for (var entry in validEntries) {
      final bib = int.tryParse(entry.bibController.text) ?? 0;
      final name = entry.nameController.text.trim();
      provider.addParticipant(bib, name);
    }
    
    // Return to previous screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Bulk Add Participants',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '#BIB',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Name',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildInputField(
                          controller: _entries[index].bibController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: _buildInputField(
                          controller: _entries[index].nameController,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _buildAddRowButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _buildCancelButton()),
                SizedBox(width: 16),
                Expanded(child: _buildSubmitButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildAddRowButton() {
    return InkWell(
      onTap: _addRow,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add Row',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _submitEntries,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ParticipantEntry {
  final TextEditingController bibController;
  final TextEditingController nameController;

  ParticipantEntry({
    required this.bibController,
    required this.nameController,
  });
}