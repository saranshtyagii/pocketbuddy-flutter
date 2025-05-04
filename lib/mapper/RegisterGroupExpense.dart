import 'GroupExpenseMetaData.dart';

class RegisterGroupExpense {
  final String groupId;
  final String description;
  final double amount;
  final String registerByUserId;
  final Map<String, GroupExpenseMetaData> includedMembers;

  const RegisterGroupExpense({
    required this.groupId,
    required this.description,
    required this.amount,
    required this.registerByUserId,
    required this.includedMembers,
  });

  factory RegisterGroupExpense.fromJson(Map<String, dynamic> json) {
    return RegisterGroupExpense(
      groupId: json['groupId'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      registerByUserId: json['registerByUserId'] as String,
      includedMembers: (json['includedMembers'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, GroupExpenseMetaData.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'description': description,
      'amount': amount,
      'registerByUserId': registerByUserId,
      'includedMembers': includedMembers.map(
            (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }
}
