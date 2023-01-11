class Proxy {
  String host;
  String port;
  String? username;
  String? password;
  bool useProxy;

  static Proxy standartProxy = Proxy(host: '185.199.229.156', port: '7492', username: 'fgrlkbxt', password: 'cs01nzezlfen');

  Proxy({required this.host, required this.port, this.username, this.password, this.useProxy = true});

  @override
  String toString() {
    return 'Proxy{ host: $host, port: $port, username: $username, password: $password,}';
  }

  String? get url {
    if (useProxy) {
      if (username != null && password != null) {
        return '$username:$password@$host:$port';
      } else {
        return '$host:$port';
      }
    }
    return null;
  }

  Proxy copyWith({
    String? host,
    String? port,
    String? username,
    String? password,
    bool? useProxy,
  }) {
    return Proxy(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      useProxy: useProxy ?? this.useProxy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'useProxy': useProxy ? 1 : 0
    };
  }

  factory Proxy.fromMap(Map<String, dynamic> map) {
    return Proxy(
      host: map['host'],
      port: map['port'],
      username: map['username'].isEmpty ? null : map['username'],
      password: map['password'].isEmpty ? null : map['password'],
      useProxy: map['useProxy'] == 1
    );
  }
}
