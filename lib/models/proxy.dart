class Proxy {
  String host;
  String port;
  String? username;
  String? password;

  static Proxy standartProxy = Proxy(host: '185.199.229.156', port: '7492', username: 'fgrlkbxt', password: 'cs01nzezlfen');

  Proxy({required this.host, required this.port, this.username, this.password});

  @override
  String toString() {
    return 'Proxy{ host: $host, port: $port, username: $username, password: $password,}';
  }

  String get url {
    if (username != null && password != null) {
      return '$username:$password@$host:$port';
    } else {
      return '$host:$port';
    }
  }

  Proxy copyWith({
    String? host,
    String? port,
    String? username,
    String? password,
  }) {
    return Proxy(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
    };
  }

  factory Proxy.fromMap(Map<String, dynamic> map) {
    return Proxy(
      host: map['host'],
      port: map['port'],
      username: map['username'],
      password: map['password'],
    );
  }
}
