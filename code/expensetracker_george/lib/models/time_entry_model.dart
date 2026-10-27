class TimeEntry {
  final String id;
  final String expenseId;
  final String categoryId;
  final double amount;
  final String businessName;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.expenseId,
    required this.categoryId,
    required this.amount,
    required this.businessName,
    required this.date,
    required this.notes,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      expenseId: json['expenseId'],
      categoryId: json['categoryId'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      businessName: json['businessName'] ?? '',
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseId': expenseId,
      'categoryId': categoryId,
      'amount': amount,
      'businessName': businessName,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
