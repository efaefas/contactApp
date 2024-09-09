class ResponseModel<T> {
  bool? success;
  List<String>? messages;
  T? data;
  int? status;

  ResponseModel({this.success, this.messages, this.data, this.status});

  ResponseModel.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    success = json['success'];

    messages = json['messages'] != null
        ? (json['messages'] as List).cast<String>()
        : [];

    if (json['data'] != null) {
      if (json['data'] is String) {
        data = fromJsonModel(json['data']);
      } else if (json['data'] is Map) {
        final dataJson = json['data'] as Map<String, dynamic>;
        if (dataJson.containsKey('users') && dataJson['users'] is List) {
          data = fromJsonModel(dataJson['users']);
        } else if (dataJson.containsKey('imageUrl')) {
          data = dataJson['imageUrl'] as T;
        }
      }
    }

    status = json['status'];
  }


  bool get isSuccess {
    return success == true;
  }

  Map<String, dynamic> toJson(Function toJsonModel) {
    final Map<String, dynamic> item = <String, dynamic>{};
    item['success'] = success;
    item['messages'] = messages;
    if (data != null) {
      item['data'] = toJsonModel(data);
    }
    item['status'] = this.status;
    return item;
  }
}
