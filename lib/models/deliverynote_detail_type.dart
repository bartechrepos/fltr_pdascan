import 'package:fltr_pdascan/models/product_type.dart';

class DeliverynoteDetailType {
  int id;
  int quantity;
  int scanned;
  ProductType product;

  DeliverynoteDetailType();

  factory DeliverynoteDetailType.fromJson(Map<dynamic, dynamic> json) {
    DeliverynoteDetailType deliveryDetail = new DeliverynoteDetailType();
    deliveryDetail.id = json['id'];
    deliveryDetail.quantity = json['quantity'];
    deliveryDetail.product = ProductType.fromJson(json['product']);
    return deliveryDetail;
  }
}
