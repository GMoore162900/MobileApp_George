import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/time_entry_model.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  List<TimeEntry> _timeEntries = [];
  List<Expense> _projects = [];
  List<SubCategory> _category = [];

  List<TimeEntry> get timeEntries => _timeEntries;
  List<Expense> get projects => _projects;
  List<SubCategory> get category => _category;
  List<SubCategory> get tasks => _category;

  TimeEntryProvider(this.storage) {
    _loadProjectsFromStorage();
    _loadTasksFromStorage();
    _loadTimeEntriesFromStorage();
  }

  void _loadTimeEntriesFromStorage() {
    final storedTimeEntries = storage.getItem('timeEntries');
    if (storedTimeEntries != null) {
      final List<dynamic> decoded = jsonDecode(storedTimeEntries);
      _timeEntries = decoded
          .map((item) => TimeEntry.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    } else {
      _saveTimeEntriesToStorage();
    }
  }

  void _loadProjectsFromStorage() {
    if (_projects.isEmpty) {
      _projects = [
        Expense(id: '1', name: 'Food', isDefault: true),
        Expense(id: '2', name: 'Transportation', isDefault: false),
        Expense(id: '3', name: 'Entertainment', isDefault: false),
        Expense(id: '4', name: 'Housing', isDefault: false),
      ];
    }

    final storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      final List<dynamic> decoded = jsonDecode(storedProjects);
      _projects = decoded
          .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    } else {
      _saveProjectsToStorage();
    }
  }

  void _loadTasksFromStorage() {
    if (_category.isEmpty) {
      _category = [
        SubCategory(id: '1', name: 'Groceries'),
        SubCategory(id: '2', name: 'Dining'),
        SubCategory(id: '3', name: 'Fuel'),
        SubCategory(id: '4', name: 'Movies'),
        SubCategory(id: '5', name: 'Rent'),
      ];
    }

    final storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      final List<dynamic> decoded = jsonDecode(storedTasks);
      _category = decoded
          .map((item) => SubCategory.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    } else {
      _saveTasksToStorage();
    }
  }

  void _saveTimeEntriesToStorage() {
    storage.setItem(
      'timeEntries',
      jsonEncode(_timeEntries.map((e) => e.toJson()).toList()),
    );
  }

  void _saveProjectsToStorage() {
    storage.setItem(
      'projects',
      jsonEncode(_projects.map((p) => p.toJson()).toList()),
    );
  }

  void _saveTasksToStorage() {
    storage.setItem(
      'tasks',
      jsonEncode(_category.map((t) => t.toJson()).toList()),
    );
  }

  void addTimeEntry(TimeEntry timeEntry) {
    _timeEntries.add(timeEntry);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void addOrUpdateTimeEntries(TimeEntry timeEntry) {
    final index = _timeEntries.indexWhere((item) => item.id == timeEntry.id);
    if (index != -1) {
      _timeEntries[index] = timeEntry;
    } else {
      _timeEntries.add(timeEntry);
    }
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _timeEntries.removeWhere((timeEntry) => timeEntry.id == id);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void addProject(Expense project) {
    final name = project.name.trim();
    if (name.isEmpty || _projects.any((item) => item.name.toLowerCase() == name.toLowerCase())) {
      return;
    }
    _projects.add(project);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void addExpense(Expense expense) => addProject(expense);

  void addCategory(SubCategory categoryItem) {
    final name = categoryItem.name.trim();
    if (name.isEmpty || _category.any((item) => item.name.toLowerCase() == name.toLowerCase())) {
      return;
    }
    _category.add(categoryItem);
    _saveTasksToStorage();
    notifyListeners();
  }

  void addTask(SubCategory task) => addCategory(task);

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _category.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }

  int generateProjectId() => _projects.length;

  int generateExpenseId() => _projects.length;

  int generateTaskId() => _category.length;

  int generateTimeEntryId() => _timeEntries.length;
}

