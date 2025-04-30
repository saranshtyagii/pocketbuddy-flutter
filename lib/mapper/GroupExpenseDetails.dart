import 'GroupExpenseMetaData.dart';

class GroupExpenseDetails {
  final String groupId;
  final String expenseId;
  final String userId;
  final String description;
  final double amount;
  final DateTime createdAt;
  final bool edited;
  final Map<String, GroupExpenseMetaData> includedMembers;

  GroupExpenseDetails(
      this.groupId,
      this.expenseId,
      this.userId,
      this.description,
      this.amount,
      this.createdAt,
      this.edited,
      this.includedMembers,
      );

  factory GroupExpenseDetails.fromJson(Map<String, dynamic> json) {
    return GroupExpenseDetails(
      json['groupId'],
      json['expenseId'],
      json['userId'],
      json['description'],
      (json['amount'] as num).toDouble(),
      DateTime.parse(json['createdAt']),
      json['edited'],
      (json['includedMembers'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, GroupExpenseMetaData.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'expenseId': expenseId,
      'userId': userId,
      'description': description,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'edited': edited,
      'includedMembers': includedMembers.map(
            (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }
}
