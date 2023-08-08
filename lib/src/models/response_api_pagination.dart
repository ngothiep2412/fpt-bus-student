import 'dart:convert';

ResponseApiPagination ResponseApiPaginationFromJson(String str) =>
    ResponseApiPagination.fromJson(json.decode(str));

String ResponseApiPaginationToJson(ResponseApiPagination data) =>
    json.encode(data.toJson());

class ResponseApiPagination {
  bool? success;
  String? message;
  dynamic data;
  Pagination? pagination;

  ResponseApiPagination({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory ResponseApiPagination.fromJson(Map<String, dynamic> json) =>
      ResponseApiPagination(
        success: json["success"],
        message: json["message"],
        pagination: Pagination.fromJson(json["pagination"]),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "pagination": pagination!.toJson(),
        "data": data,
      };
}

class Pagination {
  Pagination({
    required this.total,
    required this.limit,
    required this.currentPage,
    required this.totalPage,
  });

  int total;
  int limit;
  int currentPage;
  int totalPage;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        limit: json["limit"],
        currentPage: json["current_page"],
        totalPage: json["total_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "current_page": currentPage,
        "total_page": totalPage,
      };
}
