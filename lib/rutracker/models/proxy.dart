class Proxy {
  String host;
  int port;
  String username;
  String password;

  Proxy({required this.host, required this.port, required this.username, required this.password,});

  factory Proxy.fromJson(Map<String, dynamic> json) {
    return Proxy(
      host: json["host"],
      port: int.parse(json["port"]),
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