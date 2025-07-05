class AnnouncementQuery {
  final bool? isDeleted;
  final bool isUserIncluded;

  AnnouncementQuery({this.isDeleted, this.isUserIncluded = true});

  factory AnnouncementQuery.fromJson(Map<String, dynamic> json) {
    return AnnouncementQuery(
      isDeleted: json['isDeleted'],
      isUserIncluded: json['isUserIncluded'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (isDeleted != null) {
      json['isDeleted'] = isDeleted;
    }
    json['isUserIncluded'] = isUserIncluded;

    return json;
  }

  AnnouncementQuery.activeOnly() : this(isDeleted: false, isUserIncluded: true);

  AnnouncementQuery.deletedOnly() : this(isDeleted: true, isUserIncluded: true);

  AnnouncementQuery.all() : this(isUserIncluded: true);
}
