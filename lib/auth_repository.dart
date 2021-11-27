import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  Future<String> fetchUserIdFromAttributes() async {
    final attributes =
    await Amplify.Auth.fetchUserAttributes().catchError(_onError);
    final subAttribute =
    attributes.firstWhere((element) => element.userAttributeKey == 'sub');
    final userId = subAttribute.value;
    return userId;
  }

  Future<String> webSignIn() async {
    final result = await Amplify.Auth.signInWithWebUI().catchError(_onError);
    return result.isSignedIn
        ? await fetchUserIdFromAttributes().catchError(_onError)
        : throw Exception('could not sign in');
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut().catchError(_onError);
  }

  Future<String?> attemptAutoSignIn() async {
    final session = await Amplify.Auth.fetchAuthSession().catchError(_onError);
    if (session.isSignedIn) {
      await fetchUserIdFromAttributes().catchError(_onError);
    } else {
      throw Exception('Not signed in');
    }
  }

  _onError(Object e) {
    throw e;
  }
}
