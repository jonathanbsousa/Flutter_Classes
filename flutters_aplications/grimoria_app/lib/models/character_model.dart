import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterModel {
  final String id;
  final String name;
  final String campaignId;
  final String userId;
  // Campos opcionais que podem não estar na imagem mas são úteis
  final String? campaignName;
  final String? userName;
  final String? race;
  final String? characterClass; // No banco: class
  final int? level;
  final Map<String, dynamic> attributes; // No banco: stats

  // Campos extras mantidos para compatibilidade futura
  final int? experience;
  final int? maxHealth;
  final int? currentHealth;
  final int? maxMana;
  final int? currentMana;
  final Map<String, dynamic> skills;
  final List<String> inventory;
  final String? background;
  final String? description;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CharacterModel({
    required this.id,
    required this.name,
    required this.campaignId,
    required this.userId,
    this.campaignName,
    this.userName,
    this.race,
    this.characterClass,
    this.level,
    required this.attributes,
    this.experience,
    this.maxHealth,
    this.currentHealth,
    this.maxMana,
    this.currentMana,
    this.skills = const {},
    this.inventory = const [],
    this.background,
    this.description,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      campaignId: json['campaignId'] ?? '',
      userId: json['userId'] ?? '',
      // Mapeamento direto da imagem
      race: json['race'],
      characterClass: json['class'], // Banco usa 'class'
      level: json['level'],
      attributes: Map<String, dynamic>.from(
        json['stats'] ?? json['attributes'] ?? {},
      ), // Banco usa 'stats'
      // Campos opcionais/extras
      campaignName: json['campaignName'],
      userName: json['userName'],
      experience: json['experience'],
      maxHealth: json['maxHealth'],
      currentHealth: json['currentHealth'],
      maxMana: json['maxMana'],
      currentMana: json['currentMana'],
      skills: Map<String, dynamic>.from(json['skills'] ?? {}),
      inventory: List<String>.from(json['inventory'] ?? []),
      background: json['background'],
      description: json['description'],
      avatarUrl: json['avatarUrl'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'campaignId': campaignId,
      'userId': userId,
      'race': race,
      'class': characterClass, // Salva como 'class'
      'level': level,
      'stats': attributes, // Salva como 'stats'
      // Extras
      'campaignName': campaignName,
      'userName': userName,
      'experience': experience,
      'maxHealth': maxHealth,
      'currentHealth': currentHealth,
      'maxMana': maxMana,
      'currentMana': currentMana,
      'skills': skills,
      'inventory': inventory,
      'background': background,
      'description': description,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
    return null;
  }

  String get classRaceDisplay {
    final parts = <String>[];
    if (characterClass != null && characterClass!.isNotEmpty) parts.add(characterClass!);
    if (race != null && race!.isNotEmpty) parts.add(race!);
    
    if (parts.isEmpty) return 'Aventureiro';
    return parts.join(' / ');
  }

  String get levelDisplay => level != null ? 'Nível $level' : 'Nível 1';
}
