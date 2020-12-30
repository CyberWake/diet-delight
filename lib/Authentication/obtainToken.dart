import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'createClient.dart';

class ObtainToken {
  final storage = FlutterSecureStorage();
  fetchToken() async {
    var client = MyOAuth2Client(
        redirectUri: 'webknot.diet_delight.app://oauth2redirect',
        customUriScheme: 'webknot.diet_delight.app');
    var token = await client.getTokenWithClientCredentialsFlow(
      clientId: '2', //Your client id
      clientSecret: '3X7ar2wWTrdzAzRDl2rge1pGL5cFWLSQq7sVkMRV', //Optional
    );
    if (token.isExpired()) {
      token = await client.refreshToken(token.refreshToken);
    }
    print("This is the accessToken in function");
    print(token.accessToken);
    await storage.write(key: 'accessToken', value: token.accessToken);
    return token.accessToken;
  }
}
