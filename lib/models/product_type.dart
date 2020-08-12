class ProductType {
  int id;
  String barcode;
  String name;
  String coverImg;
  String createdAt;
  String updatedAt;

  ProductType();

  factory ProductType.fromJson(Map<dynamic, dynamic> json) {
    ProductType product = new ProductType();
    product.id = json['id'];
    product.barcode = json['barcode'];
    product.name = json['name'];
    product.coverImg = json['cover_img'];
    product.createdAt = json['created_at'];

    return product;
  }
}
