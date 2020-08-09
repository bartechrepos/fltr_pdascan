import 'package:fltr_pdascan/models/deliverynote_status_type.dart';

class DeliverynoteType {
  int id;
  int serial;
  String createdAt;
  String updatedAt;
  DeliverynoteStatusType deliverynoteStatus;

  DeliverynoteType();

  factory DeliverynoteType.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    DeliverynoteType dn = new DeliverynoteType();
    dn.id = json['id'];
    dn.serial = json['serial'];
    dn.createdAt = json['created_at'];
    dn.deliverynoteStatus =
        DeliverynoteStatusType.fromJson(json['deliverynote_status']);
    return dn;
  }
}
