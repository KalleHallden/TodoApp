import 'dart:async';
import 'api.dart';
import 'package:todoapp/models/classes/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email) 
    => apiProvider.registerUser(username, firstname, lastname, password, email);

  Future<User> signinUser(String username, String password) 
    => apiProvider.signinUser(username, password);

}