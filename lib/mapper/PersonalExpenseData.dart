class PersonalExpenseData {
  final String expenseId;
  final String description;
  final double amount;
  final DateTime expenseDate;
  final DateTime updatedDate;
  final bool isEdited;

  PersonalExpenseData(
      this.expenseId,
      this.description,
      this.amount,
      this.expenseDate,
      this.updatedDate,
      this.isEdited,
      );

  static Map<String, dynamic> convertToJson(PersonalExpenseData expenseData) {
    return {
      'expenseId': expenseData.expenseId,
      'description': expenseData.description,
      'amount': expenseData.amount,
      'expenseDate': expenseData.expenseDate,
      'updatedDate': expenseData.updatedDate,
      'edited': expenseData.isEdited,
    };
  }

  static PersonalExpenseData convertToObject(Map<String, dynamic> data) {
    return PersonalExpenseData(
      data['expenseId'],
      data['description'],
      data['amount'],
      DateTime.parse(data['expenseDate']),
      DateTime.parse(data['updatedDate']),
      data['edited'],
    );
  }



}
