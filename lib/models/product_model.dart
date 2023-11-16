import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {required this.image,
      required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.categoryId,
      required this.isFavourite,
      this.qty});

  String image;
  String id;
  String categoryId;
  bool isFavourite;
  String name;
  double price;
  String description;

  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        categoryId: json["categoryId"]??"",
        isFavourite: false,
        qty: json["qty"],
        price: double.parse(json["price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "isFavourite": isFavourite,
        "price": price,
        "categoryId": categoryId,
        "qty": qty
      };

  ProductModel copyWith({
    String? image,
    String? categoryId,
    String? name,
    String? price,
    String? description,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price != null ? double.parse(price) : this.price,
        isFavourite: false,
        categoryId: categoryId ?? this.categoryId,
        qty: 1,
      );
}
