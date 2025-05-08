import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  static const String _secretKey = "your_secret_key";

  /// Generates a JWT token using userId and situationNumber.
  static String createToken(String userId, int situationNumber) {
    final expiry = DateTime.now().add(const Duration(hours: 1));

    final payload = {
      "sub": userId,
      "exp": expiry.millisecondsSinceEpoch ~/ 1000,
      "situation": situationNumber,
    };

    final jwt = JWT(payload);

    return jwt.sign(SecretKey(_secretKey), algorithm: JWTAlgorithm.HS256);
  }
}
