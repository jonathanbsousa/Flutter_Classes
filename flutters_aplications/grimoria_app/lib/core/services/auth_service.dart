import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Register user with email and password
  Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required bool isMaster,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'isMaster': isMaster,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Return user model
        return UserModel(
          id: user.uid,
          name: name,
          email: email,
          isMaster: isMaster,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  // Login user with email and password
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Get user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            id: user.uid,
            name: userData['name'],
            email: userData['email'],
            isMaster: userData['isMaster'] ?? false,
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserModel(
          id: userId,
          name: userData['name'],
          email: userData['email'],
          isMaster: userData['isMaster'] ?? false,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao obter usuário: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    bool? isMaster,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (isMaster != null) updateData['isMaster'] = isMaster;

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }
}