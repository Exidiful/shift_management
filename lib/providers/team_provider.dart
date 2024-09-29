import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team.dart';
import '../utils/error_handler.dart';

class TeamProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Team> _teams = [];
  bool _isLoading = false;

  List<Team> get teams => _teams;
  bool get isLoading => _isLoading;

  Future<void> fetchTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore.collection('teams').get();
      _teams = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Team.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTeam(Team team) async {
    try {
      final docRef = await _firestore.collection('teams').add(team.toJson());
      final newTeam = team.copyWith(id: docRef.id);
      _teams.add(newTeam);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).update(team.toJson());
      final index = _teams.indexWhere((t) => t.id == team.id);
      if (index != -1) {
        _teams[index] = team;
        notifyListeners();
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> deleteTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).delete();
      _teams.removeWhere((t) => t.id == team.id);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Team? getTeamById(String id) {
    return _teams.firstWhere(
      (team) => team.id == id,
      orElse: () => Team(id: '', name: 'Unknown', description: '', employeeIds: []),
    );
  }
}