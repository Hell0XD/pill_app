import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:pill_app/consts.dart';

class Medication {
  String name = "";
  int dosage = 0;
  When when = When.nevermind;
  Med med = Med.caps;
  String time = "00:00";

  Medication(this.name, this.dosage, this.when, this.med, this.time);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "dosage": dosage,
      "when": when,
      "med": med,
      "time": time,
    };
  }

  Medication.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    dosage = map["dosage"];
    when = map["when"];
    med = map["med"];
    time = map["time"];
  }
}

class AppModel extends ChangeNotifier {
  List<Medication> _items = [];
  final _db = Localstore.instance;

  UnmodifiableListView<Medication> get meds => UnmodifiableListView(_items);

  AppModel() {
    _db
        .collection("meds")
        .stream
        .map(Medication.fromMap)
        .toList()
        .then((value) => _items = value).then((_) => notifyListeners());
  }

  void addMedication(Medication newMed) => _db
      .collection("meds")
      .doc(_db.collection("meds").doc().id)
      .set(newMed.toMap())
      .then((_) => _items.add(newMed));
}
