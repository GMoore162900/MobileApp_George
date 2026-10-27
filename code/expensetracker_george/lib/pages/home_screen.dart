import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data_providers/time_entry_provider.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/time_entry_model.dart';
import 'add_time_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _allEntryTabLabel = 'All Entries';
  final _groupByProjectTabLabel = 'Grouped by Categories';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: _allEntryTabLabel),
            Tab(text: _groupByProjectTabLabel),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.deepPurple),
              title: const Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tag, color: Colors.deepPurple),
              title: const Text('Manage Subcategories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTimeEntryByDate(context),
          buildTimeEntriesByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTimeEntryScreen()),
        ),
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTimeEntryByDate(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long, size: 50, color: Colors.deepPurple),
                const Text(
                  'No expenses yet!',
                  style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 55, 55, 55)),
                ),
                Text(
                  'Click the + button to log an expense.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.timeEntries.length,
          itemBuilder: (context, index) {
            final timeEntry = provider.timeEntries[index];
            final formattedDate = DateFormat('MMM dd, yyyy').format(timeEntry.date);

            return Dismissible(
              key: Key(timeEntry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => provider.deleteTimeEntry(timeEntry.id),
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                    '${getExpenseNameById(context, timeEntry.expenseId)} - ${getCategoryNameById(context, timeEntry.categoryId)}',
                  ),
                  subtitle: Text(
                    'Amount: \$${timeEntry.amount.toStringAsFixed(2)}\n'
                    'Date: $formattedDate\n'
                    'Business: ${timeEntry.businessName}\n'
                    'Note: ${timeEntry.notes.isNotEmpty ? timeEntry.notes : 'None'}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTimeEntryScreen(
                        initialTimeEntry: timeEntry,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTimeEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long, size: 50, color: Colors.deepPurple),
                const Text(
                  'No expenses yet!',
                  style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 55, 55, 55)),
                ),
                Text(
                  'Tap the + button to add your first expense.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }

        final grouped = groupBy(provider.timeEntries, (TimeEntry entry) => entry.expenseId);

        return ListView(
          children: grouped.entries.map((entry) {
            final categoryName = getExpenseNameById(context, entry.key);
            final total = entry.value.fold(
              0.0,
              (previousValue, element) => previousValue + element.amount,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$categoryName  •  \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final timeEntry = entry.value[index];
                    return ListTile(
                      leading: const Text('-'),
                      title: Text(
                        '${getCategoryNameById(context, timeEntry.categoryId)}: '
                        '\$${timeEntry.amount.toStringAsFixed(2)} '
                        '(${DateFormat('MMM dd, yyyy').format(timeEntry.date)})',
                      ),
                      subtitle: Text(timeEntry.businessName),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String getExpenseNameById(BuildContext context, String expenseId) {
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);
    final expense = provider.projects.firstWhere(
      (item) => item.id == expenseId,
      orElse: () => Expense(id: '', name: 'Unknown'),
    );
    return expense.name;
  }

  String getCategoryNameById(BuildContext context, String categoryId) {
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);
    final category = provider.category.firstWhere(
      (item) => item.id == categoryId,
      orElse: () => SubCategory(id: '', name: 'Unknown'),
    );
    return category.name;
  }
}
