class PaginationModel<T> {
  Iterable<T>? items;
  int? page;
  int? pageSize;
  int? totalItemCount;
  int? totalPages;

  PaginationModel(
      {this.items,
      this.page,
      this.pageSize,
      this.totalItemCount,
      this.totalPages});

  PaginationModel.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    if (json['items'] != null) {
      final itemsJson = json['items'].cast<Map<String, dynamic>>();
      items =
          List<T>.from(itemsJson.map((itemsJson) => fromJsonModel(itemsJson)));
    }
    page = json['page'];
    pageSize = json['pageSize'];
    totalItemCount = json['totalItemCount'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson(Function toJsonModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = toJsonModel(items);
    }
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['totalItemCount'] = totalItemCount;
    data['totalPages'] = totalPages;
    return data;
  }
}
