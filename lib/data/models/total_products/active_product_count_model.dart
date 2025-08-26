class ActiveProductCountModel {
  final bool scanner;
  final bool research;
  final bool breakfast;

  ActiveProductCountModel({
    required this.scanner,
    required this.research,
    required this.breakfast,
  });

  factory ActiveProductCountModel.fromJson(Map<String, dynamic> json) {
    return ActiveProductCountModel(
      scanner: json['scanner'] as bool,
      research: json['research'] as bool,
      breakfast: json['breakfast'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scanner': scanner,
      'research': research,
      'breakfast': breakfast,
    };
  }
}
