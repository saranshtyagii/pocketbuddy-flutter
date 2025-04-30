class GroupExpenseMetaData {
  final String userFullName;
  final double amount;

  GroupExpenseMetaData(this.userFullName, this.amount);

  factory GroupExpenseMetaData.fromJson(Map<String, dynamic> json) {
    return GroupExpenseMetaData(
      json['userFullName'],
      (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userFullName': userFullName,
      'amount': amount,
    };
  }
}
