class TokenService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  String? _authToken;

  void setToken(String token) {
    _authToken = token;
  }

  String? getToken() {
    return _authToken;
  }

  bool hasToken() {
    return _authToken != null && _authToken!.isNotEmpty;
  }

  void clearToken() {
    _authToken = null;
  }

  Map<String, String> getAuthHeaders() {
    if (hasToken()) {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };
    }
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }
}
