import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/campaign_model.dart';
import '../../models/character_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Campaign operations
  Future<CampaignModel?> getCampaignById(String campaignId) async {
    try {
      final doc = await _firestore.collection('campaigns').doc(campaignId).get();
      if (doc.exists) {
        return CampaignModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting campaign: $e');
      return null;
    }
  }

  Future<List<CampaignModel>> getCampaignsByMaster(String masterId) async {
    try {
      final snapshot = await _firestore
          .collection('campaigns')
          .where('masterId', isEqualTo: masterId)
          .get();
      
      return snapshot.docs.map((doc) => CampaignModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting campaigns by master: $e');
      return [];
    }
  }

  Future<List<CampaignModel>> getCampaignsByPlayer(String playerId) async {
    try {
      final snapshot = await _firestore
          .collection('campaigns')
          .where('playerIds', arrayContains: playerId)
          .get();
      
      return snapshot.docs.map((doc) => CampaignModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting campaigns by player: $e');
      return [];
    }
  }

  Future<List<CampaignModel>> getAllCampaigns() async {
    try {
      final snapshot = await _firestore.collection('campaigns').get();
      return snapshot.docs.map((doc) => CampaignModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting all campaigns: $e');
      return [];
    }
  }

  Future<CampaignModel?> getCampaignByCode(String code) async {
    try {
      final snapshot = await _firestore
          .collection('campaigns')
          .where('code', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return CampaignModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting campaign by code: $e');
      return null;
    }
  }

  Future<String> createCampaign(CampaignModel campaign) async {
    try {
      final docRef = await _firestore.collection('campaigns').add(campaign.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating campaign: $e');
      rethrow;
    }
  }

  Future<void> updateCampaign(CampaignModel campaign) async {
    try {
      await _firestore.collection('campaigns').doc(campaign.id).update(campaign.toJson());
    } catch (e) {
      print('Error updating campaign: $e');
      rethrow;
    }
  }

  Future<void> deleteCampaign(String campaignId) async {
    try {
      await _firestore.collection('campaigns').doc(campaignId).delete();
    } catch (e) {
      print('Error deleting campaign: $e');
      rethrow;
    }
  }

  Future<void> addPlayerToCampaign(String campaignId, String playerId) async {
    try {
      await _firestore.collection('campaigns').doc(campaignId).update({
        'playerIds': FieldValue.arrayUnion([playerId])
      });
    } catch (e) {
      print('Error adding player to campaign: $e');
      rethrow;
    }
  }

  Future<void> removePlayerFromCampaign(String campaignId, String playerId) async {
    try {
      await _firestore.collection('campaigns').doc(campaignId).update({
        'playerIds': FieldValue.arrayRemove([playerId])
      });
    } catch (e) {
      print('Error removing player from campaign: $e');
      rethrow;
    }
  }

  // Character operations
  Future<CharacterModel?> getCharacterById(String characterId) async {
    try {
      final doc = await _firestore.collection('characters').doc(characterId).get();
      if (doc.exists) {
        return CharacterModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting character: $e');
      return null;
    }
  }

  Future<List<CharacterModel>> getCharactersByCampaign(String campaignId) async {
    try {
      final snapshot = await _firestore
          .collection('characters')
          .where('campaignId', isEqualTo: campaignId)
          .get();
      
      return snapshot.docs.map((doc) => CharacterModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting characters by campaign: $e');
      return [];
    }
  }

  Future<List<CharacterModel>> getCharactersByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('characters')
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs.map((doc) => CharacterModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting characters by user: $e');
      return [];
    }
  }

  Future<String> createCharacter(CharacterModel character) async {
    try {
      final docRef = await _firestore.collection('characters').add(character.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating character: $e');
      rethrow;
    }
  }

  Future<void> updateCharacter(CharacterModel character) async {
    try {
      await _firestore.collection('characters').doc(character.id).update(character.toJson());
    } catch (e) {
      print('Error updating character: $e');
      rethrow;
    }
  }

  Future<void> deleteCharacter(String characterId) async {
    try {
      await _firestore.collection('characters').doc(characterId).delete();
    } catch (e) {
      print('Error deleting character: $e');
      rethrow;
    }
  }

  // Real-time listeners
  Stream<UserModel?> userStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserModel.fromJson(snapshot.data()!);
          }
          return null;
        });
  }

  Stream<List<CampaignModel>> campaignsByMasterStream(String masterId) {
    return _firestore
        .collection('campaigns')
        .where('masterId', isEqualTo: masterId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampaignModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<CampaignModel>> campaignsByPlayerStream(String playerId) {
    return _firestore
        .collection('campaigns')
        .where('playerIds', arrayContains: playerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampaignModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<CharacterModel>> charactersByCampaignStream(String campaignId) {
    return _firestore
        .collection('characters')
        .where('campaignId', isEqualTo: campaignId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CharacterModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<CharacterModel>> charactersByUserStream(String userId) {
    return _firestore
        .collection('characters')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CharacterModel.fromJson(doc.data()))
            .toList());
  }
}