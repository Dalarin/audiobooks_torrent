class Proxy {
  String host;
  int port;
  String username;
  String password;
  static Proxy standartProxy = Proxy(
    host: '185.199.228.220',
    port: 7300,
    username: 'bbwknegm',
    password: 'jijerh0tcg8r',
  );

  Proxy({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });

  factory Proxy.fromJson(Map<String, dynamic> json) {
    return Proxy(
      host: json["host"],
      port: json["port"],
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "host": host,
      "port": port,
      "username": username,
      "password": password,
    };
  }

//

}
