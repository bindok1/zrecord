class History {
  History({
    this.idHistory,
    this.idUser,
    this.type,
    this.date,
    this.total,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  final String? idHistory;
  final String? idUser;
  final String? type;
  final String? date;
  final String? total;
  final String? details;
  final String? createdAt;
  final String? updatedAt;

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      idHistory: json["id_history"],
      idUser: json["id_user"],
      type: json["type"],
      date: json["date"],
      total: json["total"],
      details: json["details"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_history": idHistory,
        "id_user": idUser,
        "type": type,
        "date": date,
        "total": total,
        "details": details,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
