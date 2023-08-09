class ResponseModel<T> {
  bool? result;
  String? message;
  T? item;

  ResponseModel({this.result, this.message, this.item});

  ResponseModel.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    result = json['result'];
    message = json['message'];
    if (json['item'] != null) {
      if(json['item'] is bool){
        item = json['item'];
      } else if(json['item'] is List){
        item = fromJsonModel(json['item']);
      }else {
        final itemJson = json['item'].cast<String, dynamic>();
        item = fromJsonModel(itemJson);
      }

    }
  }

  bool get isSuccess {
    return result == true;
  }

  Map<String, dynamic> toJson(Function toJsonModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (item != null) {
      data['item'] = toJsonModel(item);
    }
    return data;
  }
}
