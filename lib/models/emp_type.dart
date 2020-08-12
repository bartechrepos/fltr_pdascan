import 'dart:convert';

import 'package:fltr_pdascan/models/emptype_type.dart';

class EmpType {
  int id;
  int serial;
  String arname;
  EmptypeType empType;

  EmpType();

  @override
  String toString() {
    return this.toJson();
  }

  String toJson() {
    return json.encode({
      "id": id,
      "serial": serial,
      "arname": arname,
      "user_type": {
        "id": empType?.id,
        "step": empType?.step,
        "name": empType?.name,
        "arname": empType?.arname
      }
    });
  }

  factory EmpType.fromString(String empJsonString) {
    var decoded = json.decode(empJsonString);
    EmpType emp = new EmpType();
    emp.id = int.parse(decoded['id'].toString());
    emp.serial = int.parse(decoded['serial'].toString());
    emp.arname = decoded['arname'];
    emp.empType = EmptypeType.fromJson(decoded['user_type']);
    return emp;
  }

  factory EmpType.fromJson(Map<dynamic, dynamic> json) {
    EmpType emp = new EmpType();
    emp.id = json['id'];
    emp.serial = json['serial'];
    emp.arname = json['arname'];
    if (json['user_type'] != null) {
      try {
        emp.empType = EmptypeType.fromJson(json['user_type']);
      } catch (e) {
        print('The provided string is not valid JSON');
      }
    }

    return emp;
  }
}
