import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data_providers/time_entry_provider.dart';
import '../models/time_entry_model.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialTimeEntry;

  const AddTimeEntryScreen({super.key, this.initialTimeEntry});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _amountController;
  late TextEditingController _businessNameController;
  late TextEditingController _noteController;
  String? _selectedExpenseId;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialTimeEntry?.amount.toString() ?? '',
    );
    _businessNameController = TextEditingController(
      text: widget.initialTimeEntry?.businessName ?? '',
    );
    _noteController = TextEditingController(
      text: widget.initialTimeEntry?.notes ?? '',
    );
    _selectedDate = widget.initialTimeEntry?.date ?? DateTime.now();
    _selectedExpenseId = widget.initialTimeEntry?.expenseId;
    _selectedCategoryId = widget.initialTimeEntry?.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final timeProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTimeEntry == null ? 'Add Expense' : 'Edit Expense',
        ),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildProjectDropdown(timeProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildTaskDropdown(timeProvider),
            ),
            buildDateField(_selectedDate),
            buildTextField(
              _amountController,
              'Amount',
              const TextInputType.numberWithOptions(decimal: true),
            ),
            buildTextField(
              _businessNameController,
              'Business / Person',
              TextInputType.text,
            ),
            buildTextField(
              _noteController,
              'Note',
              TextInputType.text,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _saveTimeEntry,
          child: const Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveTimeEntry() {
    if (_amountController.text.trim().isEmpty ||
        _businessNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    if (_selectedExpenseId == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an expense category and subcategory.'),
        ),
      );
      return;
    }

    final parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount greater than zero.')),
      );
      return;
    }

    final provider = Provider.of<TimeEntryProvider>(context, listen: false);
    final timeEntry = TimeEntry(
      id: widget.initialTimeEntry?.id ??
          provider.generateTimeEntryId().toString(),
      expenseId: _selectedExpenseId!,
      categoryId: _selectedCategoryId!,
      amount: parsedAmount,
      businessName: _businessNameController.text.trim(),
      date: _selectedDate,
      notes: _noteController.text.trim(),
    );

    provider.addOrUpdateTimeEntries(timeEntry);
    Navigator.pop(context);
  }

  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedExpenseId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(
              onAdd: (newCategory) {
                setState(() {
                  _selectedExpenseId = newCategory.id;
                });
              },
            ),
          );
        } else {
          setState(() => _selectedExpenseId = newValue);
        }
      },
      items: provider.projects.map<DropdownMenuItem<String>>((project) {
        return DropdownMenuItem<String>(
          value: project.id,
          child: Text(project.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: 'New',
          child: Text('Add New Category'),
        )),
      decoration: const InputDecoration(
        labelText: 'Expense Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newCategory) {
                setState(() {
                  _selectedCategoryId = newCategory.id;
                });
              },
            ),
          );
        } else {
          setState(() => _selectedCategoryId = newValue);
        }
      },
      items: provider.category.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: 'New',
          child: Text('Add New Subcategory'),
        )),
      decoration: const InputDecoration(
        labelText: 'Expense Subcategory',
        border: OutlineInputBorder(),
      ),
    );
  }
}

