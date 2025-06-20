class RoomQuery {
  final String? name;
  final String? type;
  final bool? isActive;

  RoomQuery({this.name, this.type, this.isActive});

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

  factory RoomQuery.all() {
    return RoomQuery();
  }
}
