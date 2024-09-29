import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../models/employee.dart';
import '../widgets/employee_dialog.dart';

class EmployeeManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Management')),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
          if (employeeProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: employeeProvider.employees.length,
            itemBuilder: (context, index) {
              final employee = employeeProvider.employees[index];
              return ListTile(
                title: Text(employee.name),
                subtitle: Text(employee.position),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editEmployee(context, employeeProvider, employee),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteEmployee(context, employeeProvider, employee),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addEmployee(context),
      ),
    );
  }

  void _addEmployee(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        onSave: (Employee newEmployee) {
          Provider.of<EmployeeProvider>(context, listen: false).addEmployee(newEmployee);
        },
      ),
    );
  }

  void _editEmployee(BuildContext context, EmployeeProvider provider, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        employee: employee,
        onSave: (Employee updatedEmployee) {
          provider.updateEmployee(updatedEmployee);
        },
      ),
    );
  }

  void _deleteEmployee(BuildContext context, EmployeeProvider provider, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              provider.deleteEmployee(employee);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}