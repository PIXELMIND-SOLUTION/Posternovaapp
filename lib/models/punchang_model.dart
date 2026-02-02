class PanchangResponse {
  final String status;
  final UserInfo user;
  final PanchangData data;

  PanchangResponse({
    required this.status,
    required this.user,
    required this.data,
  });

  factory PanchangResponse.fromJson(Map<String, dynamic> json) {
    return PanchangResponse(
      status: json['status'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      data: PanchangData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user': user.toJson(),
      'data': data.toJson(),
    };
  }
}

class UserInfo {
  final String name;
  final String email;
  final String mobile;
  final String dob;

  UserInfo({
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      dob: json['dob'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
    };
  }
}

class PanchangData {
  final String vaara;
  final List<Nakshatra> nakshatra;
  final List<Tithi> tithi;
  final List<Karana> karana;
  final List<Yoga> yoga;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;

  PanchangData({
    required this.vaara,
    required this.nakshatra,
    required this.tithi,
    required this.karana,
    required this.yoga,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
  });

  factory PanchangData.fromJson(Map<String, dynamic> json) {
    return PanchangData(
      vaara: json['vaara'] ?? '',
      nakshatra: (json['nakshatra'] as List?)
              ?.map((e) => Nakshatra.fromJson(e))
              .toList() ??
          [],
      tithi: (json['tithi'] as List?)
              ?.map((e) => Tithi.fromJson(e))
              .toList() ??
          [],
      karana: (json['karana'] as List?)
              ?.map((e) => Karana.fromJson(e))
              .toList() ??
          [],
      yoga: (json['yoga'] as List?)
              ?.map((e) => Yoga.fromJson(e))
              .toList() ??
          [],
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
      moonrise: json['moonrise'] ?? '',
      moonset: json['moonset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaara': vaara,
      'nakshatra': nakshatra.map((e) => e.toJson()).toList(),
      'tithi': tithi.map((e) => e.toJson()).toList(),
      'karana': karana.map((e) => e.toJson()).toList(),
      'yoga': yoga.map((e) => e.toJson()).toList(),
      'sunrise': sunrise,
      'sunset': sunset,
      'moonrise': moonrise,
      'moonset': moonset,
    };
  }
}

class Nakshatra {
  final int id;
  final String name;
  final Lord lord;
  final String start;
  final String end;

  Nakshatra({
    required this.id,
    required this.name,
    required this.lord,
    required this.start,
    required this.end,
  });

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    return Nakshatra(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lord: Lord.fromJson(json['lord'] ?? {}),
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lord': lord.toJson(),
      'start': start,
      'end': end,
    };
  }
}

class Lord {
  final int id;
  final String name;
  final String vedicName;

  Lord({
    required this.id,
    required this.name,
    required this.vedicName,
  });

  factory Lord.fromJson(Map<String, dynamic> json) {
    return Lord(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      vedicName: json['vedic_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vedic_name': vedicName,
    };
  }
}

class Tithi {
  final int id;
  final int index;
  final String name;
  final String paksha;
  final String start;
  final String end;

  Tithi({
    required this.id,
    required this.index,
    required this.name,
    required this.paksha,
    required this.start,
    required this.end,
  });

  factory Tithi.fromJson(Map<String, dynamic> json) {
    return Tithi(
      id: json['id'] ?? 0,
      index: json['index'] ?? 0,
      name: json['name'] ?? '',
      paksha: json['paksha'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'paksha': paksha,
      'start': start,
      'end': end,
    };
  }
}

class Karana {
  final int index;
  final int id;
  final String name;
  final String start;
  final String end;

  Karana({
    required this.index,
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  factory Karana.fromJson(Map<String, dynamic> json) {
    return Karana(
      index: json['index'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'id': id,
      'name': name,
      'start': start,
      'end': end,
    };
  }
}

class Yoga {
  final int id;
  final String name;
  final String start;
  final String end;

  Yoga({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  factory Yoga.fromJson(Map<String, dynamic> json) {
    return Yoga(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start': start,
      'end': end,
    };
  }
}