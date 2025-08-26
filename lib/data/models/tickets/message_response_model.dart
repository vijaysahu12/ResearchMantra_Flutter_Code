import 'package:research_mantra_official/data/models/tickets/images_response_model.dart';

class MessagResponesModel {
  final int? id;
  final List<Messages>? messages;
  const MessagResponesModel({this.id, this.messages});
  MessagResponesModel copyWith({int? id, List<Messages>? messages}) {
    return MessagResponesModel(
        id: id ?? this.id, messages: messages ?? this.messages);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'messages':
          messages?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static MessagResponesModel fromJson(Map<String, dynamic> json) {
    return MessagResponesModel(
        id: json['id'] == null ? null : json['id'] as int,
        messages: json['messages'] == null
            ? null
            : (json['messages'] as List)
                .map<Messages>(
                    (data) => Messages.fromJson(data as Map<String, dynamic>))
                .toList());
  }
}

class Messages {
  final int? id;
  final String? content;
  final String? sender;
  final String? timestamp;
  final String? ticketStatus;
  final List<Images>? images;

  const Messages({
    this.id,
    this.content,
    this.sender,
    this.timestamp,
    this.ticketStatus,
    this.images,
  });
  Messages copyWith({
    int? id,
    String? content,
    String? sender,
    String? timestamp,
    String? ticketStatus,
    List<Images>? images,
  }) {
    return Messages(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      ticketStatus: ticketStatus ?? this.ticketStatus,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp,
      'ticketStatus': ticketStatus,
      'images':
          images?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  static Messages fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'] == null ? null : json['id'] as int,
      content: json['content'] == null ? null : json['content'] as String,
      sender: json['sender'] == null ? null : json['sender'] as String,
      timestamp: json['timestamp'] == null ? null : json['timestamp'] as String,
      ticketStatus:
          json['ticketStatus'] == null ? null : json['ticketStatus'] as String,
      images: json['images'] == null
          ? null
          : (json['images'] as List)
              .map<Images>(
                  (data) => Images.fromJson(data as Map<String, dynamic>))
              .toList(),
    );
  }
}
