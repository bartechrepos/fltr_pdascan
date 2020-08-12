class DeliverynoteStatusType {
  int id;
  String statusName;
  String hexcode;
  String statusArname;
  DeliverynoteStatusType();

  factory DeliverynoteStatusType.fromJson(Map<dynamic, dynamic> json) {
    DeliverynoteStatusType type = new DeliverynoteStatusType();
    type.id = json['id'];
    type.statusName = json['status_name'];
    type.statusArname = json['status_arname'];
    type.hexcode = json['hexcode'];
    return type;
  }
}
