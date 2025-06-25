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

  RoomQuery.activeOnly() : this(isActive: true);

  RoomQuery.inactiveOnly() : this(isActive: false);

  RoomQuery.byType(String roomType) : this(type: roomType);

  RoomQuery.byName(String roomName) : this(name: roomName);

  RoomQuery.all() : this();
}
