
class User {
  User({
    this.idUser,
    this.name,
    this.password,
    this.createdAt,
    this.email,
    this.updatedAt,
  });

  final String? idUser;
  final String? email;
  final String? name;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json["id_user"],
      email: json["email"],
      name: json["name"],
      password: json["password"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "name": name,
        "password": password,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "email": email,
      };
}
