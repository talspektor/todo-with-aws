import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  Future<String> fetchUserIdFromAttributes() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final subAttribute =
        attributes.firstWhere((element) => element.userAttributeKey == 'sub');
    final userId = subAttribute.value;
    return userId;
  }

  Future<String> webSignIn() async {
    try {
      final result = await Amplify.Auth.signInWithWebUI();
      if (result.isSignedIn) {
        return await fetchUserIdFromAttributes();
      } else {
        throw Exception('could not sign in');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  Future<String> attemptAutoSignIn() async {
    try {
      return await fetchUserIdFromAttributes();
    } catch (e) {
      throw e;
    }
  }
}
