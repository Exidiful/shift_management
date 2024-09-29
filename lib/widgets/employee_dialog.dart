import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../utils/app_theme.dart';

class EmployeeDialog extends StatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;

  EmployeeDialog({this.employee, required this.onSave});

  @override
  _EmployeeDialogState createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<EmployeeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phoneNumber ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.employee == null ? 'Add Employee' : 'Edit Employee',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_positionController, 'Position'),
            _buildTextField(_emailController, 'Email', TextInputType.emailAddress),
            _buildTextField(_phoneController, 'Phone Number', TextInputType.phone),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: AppTheme.accentColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.accentColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            final employee = Employee(
              id: widget.employee?.id ?? '',
              name: _nameController.text,
              position: _positionController.text,
              email: _emailController.text,
              phoneNumber: _phoneController.text,
            );
            widget.onSave(employee);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.primaryColor.withOpacity(0.6)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}