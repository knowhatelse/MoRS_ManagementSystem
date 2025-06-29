class RoomQuery {
  final String? name;
  final String? type;
  final bool? isActive;

  RoomQuery({this.name, this.type, this.isActive});

  factory RoomQuery.fromJson(Map<String, dynamic> json) {
    return RoomQuery(
      name: json['name'],
      type: json['type'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (name != null && name!.isNotEmpty) {
      json['name'] = name;
    }
    if (type != null && type!.isNotEmpty) {
      json['type'] = type;
    }
    if (isActive != null) {
      json['isActive'] = isActive;
    }

    return json;
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (name != null && name!.isNotEmpty) {
      params['name'] = name!;
    }
    if (type != null && type!.isNotEmpty) {
      params['type'] = type!;
    }
    if (isActive != null) {
      params['isActive'] = isActive.toString();
    }

    return params;
  }

  factory RoomQuery.activeOnly() {
    return RoomQuery(isActive: true);
  }

  factory RoomQuery.inactiveOnly() {
    return RoomQuery(isActive: false);
  }

  factory RoomQuery.byType(String roomType) {
    return RoomQuery(type: roomType);
  }

  factory RoomQuery.byName(String roomName) {
    return RoomQuery(name: roomName);
  }

  factory RoomQuery.all() {
    return RoomQuery();
  }
}
