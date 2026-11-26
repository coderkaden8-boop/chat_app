class RequestOllamaApi {
  RequestOllamaApi({
      this.model, 
      this.messages, 
      this.stream,});

  RequestOllamaApi.fromJson(dynamic json) {
    model = json['model'];
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
    stream = json['stream'];
  }
  String? model;
  List<Messages>? messages;
  bool? stream;
RequestOllamaApi copyWith({  String? model,
  List<Messages>? messages,
  bool? stream,
}) => RequestOllamaApi(  model: model ?? this.model,
  messages: messages ?? this.messages,
  stream: stream ?? this.stream,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['model'] = model;
    if (messages != null) {
      map['messages'] = messages?.map((v) => v.toJson()).toList();
    }
    map['stream'] = stream;
    return map;
  }

}

class Messages {
  Messages({
      this.role, 
      this.content,});

  Messages.fromJson(dynamic json) {
    role = json['role'];
    content = json['content'];
  }
  String? role;
  String? content;
Messages copyWith({  String? role,
  String? content,
}) => Messages(  role: role ?? this.role,
  content: content ?? this.content,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['role'] = role;
    map['content'] = content;
    return map;
  }

}