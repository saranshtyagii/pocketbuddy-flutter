class UserJoinGroup {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String createdByUserId;
  final DateTime createdAt;
  final Map<String, num> joinedMembers;

  UserJoinGroup({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.createdByUserId,
    required this.createdAt,
    required this.joinedMembers,
  });

  factory UserJoinGroup.fromJson(Map<String, dynamic> json) {
    return UserJoinGroup(
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      groupDescription: json['groupDescription'] as String,
      createdByUserId: json['createdByUserId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      joinedMembers: Map<String, num>.from(json['joinedMembers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'createdByUserId': createdByUserId,
      'createdAt': createdAt.toIso8601String(),
      'joinedMembers': joinedMembers,
    };
  }
}
