import 'package:fltr_pdascan/models/deliverynote_status_type.dart';
import 'package:fltr_pdascan/models/emp_type.dart';

class DeliverynoteType {
  int id;
  int serial;
  String createdAt;
  String updatedAt;
  DeliverynoteStatusType deliverynoteStatus;
  EmpType bookedBy;

  DeliverynoteType();

  factory DeliverynoteType.fromJson(Map<dynamic, dynamic> json) {
    DeliverynoteType dn = new DeliverynoteType();
    dn.id = json['id'];
    dn.serial = json['serial'];
    dn.createdAt = json['created_at'];
    dn.deliverynoteStatus =
        DeliverynoteStatusType.fromJson(json['deliverynote_status']);
    if (json['booked_by'] != null) {
      print(json['booked_by']);
      dn.bookedBy = EmpType.fromJson(json['booked_by']);
    }

    return dn;
  }
}
