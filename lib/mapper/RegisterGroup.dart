class RegisterGroup {
  final String groupName;
  final String description;
  final String createdByUser;
  final double groupBudget;
  final double budgetPerDay;
  final DateTime tripStartDate;
  final DateTime tripEndDate;

  RegisterGroup(
      this.groupName,
      this.description,
      this.createdByUser,
      this.groupBudget,
      this.budgetPerDay,
      this.tripStartDate,
      this.tripEndDate,
      );

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'description': description,
      'createdByUser': createdByUser,
      'groupBudget': groupBudget,
      'budgetPerDay': budgetPerDay,
      'tripStartDate': tripStartDate.toIso8601String(),
      'tripEndDate': tripEndDate.toIso8601String(),
    };
  }

  // Create object from JSON
  factory RegisterGroup.fromJson(Map<String, dynamic> json) {
    return RegisterGroup(
      json['groupName'],
      json['description'],
      json['createdByUser'],
      (json['groupBudget'] as num).toDouble(),
      (json['budgetPerDay'] as num).toDouble(),
      DateTime.parse(json['tripStartDate']),
      DateTime.parse(json['tripEndDate']),
    );
  }
}
