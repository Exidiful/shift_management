import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shift.dart';
import '../models/shift_period.dart';
import '../utils/error_handler.dart';

class ShiftProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<DateTime, List<Shift>> _shifts = {};
  List<ShiftPeriod> _shiftPeriods = [];
  bool _isLoading = false;

  Map<DateTime, List<Shift>> get shifts => _shifts;
  List<ShiftPeriod> get shiftPeriods => _shiftPeriods;
  bool get isLoading => _isLoading;

  Future<void> fetchShiftPeriods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore.collection('shiftPeriods').get();
      _shiftPeriods = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ShiftPeriod.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addShiftPeriod(ShiftPeriod period) async {
    try {
      final docRef = await _firestore.collection('shiftPeriods').add(period.toMap());
      period.id = docRef.id;
      _shiftPeriods.add(period);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> updateShiftPeriod(ShiftPeriod period) async {
    try {
      await _firestore.collection('shiftPeriods').doc(period.id).update(period.toMap());
      final index = _shiftPeriods.indexWhere((p) => p.id == period.id);
      if (index != -1) {
        _shiftPeriods[index] = period;
        notifyListeners();
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> deleteShiftPeriod(String id) async {
    try {
      await _firestore.collection('shiftPeriods').doc(id).delete();
      _shiftPeriods.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> fetchShifts(DateTime month) async {
    _isLoading = true;
    notifyListeners();

    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final QuerySnapshot snapshot = await _firestore
          .collection('shifts')
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      _shifts.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final shift = Shift.fromMap(data, doc.id);
        final shiftDate = DateTime(shift.date.year, shift.date.month, shift.date.day);
        if (_shifts[shiftDate] == null) {
          _shifts[shiftDate] = [];
        }
        _shifts[shiftDate]!.add(shift);
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Shift> addShift(Shift shift) async {
    try {
      final docRef = await _firestore.collection('shifts').add(shift.toMap());
      shift.id = docRef.id;
      if (_shifts[shift.date] == null) {
        _shifts[shift.date] = [];
      }
      _shifts[shift.date]!.add(shift);
      notifyListeners();
      return shift;
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
      rethrow;
    }
  }

  Future<void> updateShift(Shift shift) async {
    try {
      await _firestore.collection('shifts').doc(shift.id).update(shift.toMap());
      final index = _shifts[shift.date]!.indexWhere((s) => s.id == shift.id);
      _shifts[shift.date]![index] = shift;
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> deleteShift(Shift shift) async {
    try {
      await _firestore.collection('shifts').doc(shift.id).delete();
      _shifts[shift.date]!.removeWhere((s) => s.id == shift.id);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> fetchEmployeeShifts(String employeeId, DateTime month) async {
    _isLoading = true;
    notifyListeners();

    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final QuerySnapshot snapshot = await _firestore
          .collection('shifts')
          .where('employeeId', isEqualTo: employeeId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      _shifts.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final shift = Shift.fromMap(data, doc.id);
        final shiftDate = DateTime(shift.date.year, shift.date.month, shift.date.day);
        if (_shifts[shiftDate] == null) {
          _shifts[shiftDate] = [];
        }
        _shifts[shiftDate]!.add(shift);
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}