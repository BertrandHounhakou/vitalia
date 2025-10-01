import 'package:vitalia/data/models/user_model.dart';

abstract class UserService {
  Future<List<UserModel>> getUsers();
  Future<void> createUser(UserModel user, String password);
  Future<void> deleteUser(String userId);
  Future<List<UserModel>> searchUsers(String query);
  Future<UserModel?> getUserById(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> updates);
}