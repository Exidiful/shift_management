import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart';
import '../utils/error_handler.dart';

class EmployeeProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore.collection('employees').get();
      _employees = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Employee.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      final docRef = await _firestore.collection('employees').add(employee.toJson());
      final newEmployee = employee.copyWith(id: docRef.id);
      _employees.add(newEmployee);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id).update(employee.toJson());
      final index = _employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        _employees[index] = employee;
        notifyListeners();
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id).delete();
      _employees.removeWhere((e) => e.id == employee.id);
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleFirestoreError(e);
    }
  }

  Employee? getEmployeeById(String id) {
    return _employees.firstWhere(
      (employee) => employee.id == id,
      orElse: () => Employee(id: '', name: 'Unknown', position: '', email: '', phoneNumber: ''),
    );
  }
}