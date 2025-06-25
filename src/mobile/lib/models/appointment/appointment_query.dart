class AppointmentQuery {
  final DateTime? date;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? roomId;
  final int? bookedByUserId;
  final int? attendeeId;
  final bool? isCancelled;
  final bool? isRepeating;
  final bool isRoomIncluded;
  final bool isAppointmentTypeIncluded;
  final bool isAppointmentScheduleIncluded;
  final bool isUserIncluded;
  final bool areAttendeesIncluded;

  AppointmentQuery({
    this.date,
    this.dateFrom,
    this.dateTo,
    this.roomId,
    this.bookedByUserId,
    this.attendeeId,
    this.isCancelled,
    this.isRepeating,
    this.isRoomIncluded = true,
    this.isAppointmentTypeIncluded = true,
    this.isAppointmentScheduleIncluded = true,
    this.isUserIncluded = true,
    this.areAttendeesIncluded = true,
  });

  factory AppointmentQuery.fromJson(Map<String, dynamic> json) {
    return AppointmentQuery(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      dateFrom: json['dateFrom'] != null
          ? DateTime.parse(json['dateFrom'])
          : null,
      dateTo: json['dateTo'] != null ? DateTime.parse(json['dateTo']) : null,
      roomId: json['roomId'],
      bookedByUserId: json['bookedByUserId'],
      attendeeId: json['attendeeId'],
      isCancelled: json['isCancelled'],
      isRepeating: json['isRepeating'],
      isRoomIncluded: json['isRoomIncluded'] ?? true,
      isAppointmentTypeIncluded: json['isAppointmentTypeIncluded'] ?? true,
      isAppointmentScheduleIncluded:
          json['isAppointmentScheduleIncluded'] ?? true,
      isUserIncluded: json['isUserIncluded'] ?? true,
      areAttendeesIncluded: json['areAttendeesIncluded'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (date != null) {
      json['date'] = date!.toIso8601String().split('T')[0];
    }
    if (dateFrom != null) {
      json['dateFrom'] = dateFrom!.toIso8601String().split('T')[0];
    }
    if (dateTo != null) {
      json['dateTo'] = dateTo!.toIso8601String().split('T')[0];
    }
    if (roomId != null) {
      json['roomId'] = roomId;
    }
    if (bookedByUserId != null) {
      json['bookedByUserId'] = bookedByUserId;
    }
    if (attendeeId != null) {
      json['attendeeId'] = attendeeId;
    }
    if (isCancelled != null) {
      json['isCancelled'] = isCancelled;
    }
    if (isRepeating != null) {
      json['isRepeating'] = isRepeating;
    }

    json['isRoomIncluded'] = isRoomIncluded;
    json['isAppointmentTypeIncluded'] = isAppointmentTypeIncluded;
    json['isAppointmentScheduleIncluded'] = isAppointmentScheduleIncluded;
    json['isUserIncluded'] = isUserIncluded;
    json['areAttendeesIncluded'] = areAttendeesIncluded;

    return json;
  }

  AppointmentQuery.forDate(DateTime date)
    : this(
        date: date,
        isRepeating: true,
        isRoomIncluded: true,
        isAppointmentTypeIncluded: true,
        isAppointmentScheduleIncluded: true,
        isUserIncluded: true,
        areAttendeesIncluded: true,
      );

  AppointmentQuery.forDateRange(DateTime dateFrom, DateTime dateTo)
    : this(
        dateFrom: dateFrom,
        dateTo: dateTo,
        isRoomIncluded: true,
        isAppointmentTypeIncluded: true,
        isAppointmentScheduleIncluded: true,
        isUserIncluded: true,
        areAttendeesIncluded: true,
      );

  AppointmentQuery.forUser(int userId)
    : this(
        bookedByUserId: userId,
        isRoomIncluded: true,
        isAppointmentTypeIncluded: true,
        isAppointmentScheduleIncluded: true,
        isUserIncluded: true,
        areAttendeesIncluded: true,
      );

  AppointmentQuery.forRoom(int roomId)
    : this(
        roomId: roomId,
        isRoomIncluded: true,
        isAppointmentTypeIncluded: true,
        isAppointmentScheduleIncluded: true,
        isUserIncluded: true,
        areAttendeesIncluded: true,
      );
}
