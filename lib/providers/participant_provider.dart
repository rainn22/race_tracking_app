import 'package:flutter/material.dart';
import 'package:race_tracking_app/async_value.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/repositories/participant_repository.dart';

class ParticipantProvider extends ChangeNotifier {
  final ParticipantRepository _repository;
  AsyncValue<List<Participant>>? participantState;
  Participant? _editingParticipant;

  ParticipantProvider(this._repository) {
    fetchParticipants();
  }

  bool get isLoading =>
      participantState != null &&
      participantState!.state == AsyncValueState.loading;
  bool get hasData =>
      participantState != null &&
      participantState!.state == AsyncValueState.success;
  bool get isEditing => _editingParticipant != null;

  void fetchParticipants() async {
    try {
      participantState = AsyncValue.loading();
      notifyListeners();

      final data = await _repository.getParticipants();
      participantState = AsyncValue.success(data);
    } catch (e) {
      participantState = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> addParticipant(int bib, String name) async {
    await _repository.addParticipant(name: name, bib: bib);
    fetchParticipants();
  }

  Future<void> deleteParticipant(String id) async {
    await _repository.deleteParticipant(id);
    fetchParticipants();
  }

  Future<void> updateParticipant(String id, int bib, String name) async {
    await _repository.updateParticipant(
      Participant(id: id, name: name, bib: bib),
    );
    _editingParticipant = null;
    fetchParticipants();
  }

  void setEditingParticipant(Participant? participant) {
    _editingParticipant = participant;
    notifyListeners();
  }

  void cancelEditing() {
    _editingParticipant = null;
    notifyListeners();
  }
}
