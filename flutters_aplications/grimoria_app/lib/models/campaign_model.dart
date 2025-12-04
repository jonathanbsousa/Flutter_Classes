import 'character_model.dart';

class CampaignModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final String masterId;
  final String masterName;
  final List<String> playerIds;
  final List<String> characterIds;
  final String status;
  final String statusColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.masterId,
    required this.masterName,
    required this.playerIds,
    required this.characterIds,
    required this.status,
    required this.statusColor,
    this.createdAt,
    this.updatedAt,
  });

  // Create from JSON (Firestore document)
  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      masterId: json['masterId'] ?? '',
      masterName: json['masterName'] ?? '',
      playerIds: List<String>.from(json['playerIds'] ?? []),
      characterIds: List<String>.from(json['characterIds'] ?? []),
      status: json['status'] ?? 'Empty',
      statusColor: json['statusColor'] ?? '#FF9800',
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'])
          : null,
    );
  }

  // Convert to JSON (Firestore document)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'masterId': masterId,
      'masterName': masterName,
      'playerIds': playerIds,
      'characterIds': characterIds,
      'status': status,
      'statusColor': statusColor,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Copy with method for easy updates
  CampaignModel copyWith({
    String? id,
    String? title,
    String? description,
    String? code,
    String? masterId,
    String? masterName,
    List<String>? playerIds,
    List<String>? characterIds,
    String? status,
    String? statusColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      masterId: masterId ?? this.masterId,
      masterName: masterName ?? this.masterName,
      playerIds: playerIds ?? this.playerIds,
      characterIds: characterIds ?? this.characterIds,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if user is master of this campaign
  bool isMaster(String userId) => masterId == userId;

  // Check if user is player in this campaign
  bool isPlayer(String userId) => playerIds.contains(userId);

  // Check if user is part of this campaign (master or player)
  bool isParticipant(String userId) => isMaster(userId) || isPlayer(userId);

  // Get number of participants
  int get participantCount => playerIds.length + 1; // +1 for master

  // Get campaign code in uppercase
  String get formattedCode => code.toUpperCase();

  // Update status based on character count
  CampaignModel updateStatus() {
    String newStatus;
    String newStatusColor;

    if (characterIds.isEmpty) {
      newStatus = 'Empty';
      newStatusColor = '#FF9800';
    } else if (characterIds.length == 1) {
      newStatus = 'Getting Started';
      newStatusColor = '#2196F3';
    } else if (characterIds.length < 4) {
      newStatus = 'Active';
      newStatusColor = '#4CAF50';
    } else {
      newStatus = 'Full';
      newStatusColor = '#F44336';
    }

    return copyWith(
      status: newStatus,
      statusColor: newStatusColor,
      updatedAt: DateTime.now(),
    );
  }

  // Manual status update
  CampaignModel updateStatusManually(String newStatus) {
    String newStatusColor;

    switch (newStatus) {
      case 'Empty':
        newStatusColor = '#FF9800';
        break;
      case 'Getting Started':
        newStatusColor = '#2196F3';
        break;
      case 'Active':
        newStatusColor = '#4CAF50';
        break;
      case 'Full':
        newStatusColor = '#F44336';
        break;
      case 'Paused':
        newStatusColor = '#9E9E9E';
        break;
      case 'Completed':
        newStatusColor = '#673AB7';
        break;
      default:
        newStatusColor = '#9E9E9E';
    }

    return copyWith(
      status: newStatus,
      statusColor: newStatusColor,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'CampaignModel(id: $id, title: $title, code: $code, master: $masterName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CampaignModel &&
        other.id == id &&
        other.title == title &&
        other.code == code &&
        other.masterId == masterId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ code.hashCode ^ masterId.hashCode;
  }
}
