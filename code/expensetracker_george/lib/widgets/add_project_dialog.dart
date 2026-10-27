import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_providers/time_entry_provider.dart';
import '../models/expense_model.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Expense) onAdd;

  const AddProjectDialog({super.key, required this.onAdd});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Expense Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Category Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) return;

            final newProject = Expense(
              id: Provider.of<TimeEntryProvider>(context, listen: false)
                  .generateExpenseId()
                  .toString(),
              name: name,
            );

            widget.onAdd(newProject);
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addExpense(newProject);
            _controller.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}