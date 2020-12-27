import 'package:oauth2_client/oauth2_client.dart';
import 'package:meta/meta.dart';

class MyOAuth2Client extends OAuth2Client {
  MyOAuth2Client(
      {@required String redirectUri, @required String customUriScheme})
      : super(
            authorizeUrl:
                'http://dietdelight.enigmaty.com/oauth/authorize', //Your service's authorization url
            tokenUrl:
                'http://dietdelight.enigmaty.com/oauth/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}
