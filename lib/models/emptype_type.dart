class EmptypeType {
  int id;
  int step;
  String arname;
  String name;
  EmptypeType();

  factory EmptypeType.fromJson(Map<dynamic, dynamic> json) {
    EmptypeType type = new EmptypeType();
    type.id = json['id'];
    type.step = json['step'];
    type.arname = json['arname'];
    type.name = json['name'];
    return type;
  }
}
