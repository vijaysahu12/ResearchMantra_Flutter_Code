class TicketResponseModel {
  final int? id;
  final String ticketType;
  final String priority;
  final String subject;
  final String description;
  final bool? isActive;
  final String status;
    final String ?createdOn;

  const TicketResponseModel({
    this.id,
    required this.ticketType,
    required this.priority,
    required this.subject,
    required this.description,
    this.isActive,
    required this.status,
    this.createdOn,
  });

  static TicketResponseModel fromJson(Map<String, dynamic> json) {
    return TicketResponseModel(
      id: json['id'] == null ? null : json['id'] as int,
      ticketType: json['ticketType'] ?? '',
      priority: json['priority'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] == null ? null : json['isActive'] as bool,
      status: json['status'] ?? 'O',
      createdOn: json['createdOn']
    );
  }

  TicketResponseModel copyWith({
    int? id,
    String? ticketType,
    String? priority,
    String? subject,
    String? description,
    String ?createdOn,
  }) {
    return TicketResponseModel(
      id: id ?? this.id,
      ticketType: ticketType ?? this.ticketType,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      status: 'O',
      createdOn: createdOn

    );
  }
}
