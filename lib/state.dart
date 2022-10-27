import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:pill_app/consts.dart';

class Medication {
  String id = "";
  String name = "";
  int dosage = 0;
  When when = When.nevermind;
  Med med = Med.caps;
  String time = "00:00";
  bool done = false;

  Medication(this.name, this.dosage, this.when, this.med, this.time);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "dosage": dosage,
      "when": whenOptions[when],
      "med": medOptions[med],
      "time": time,
      "done": done,
    };
  }

  Medication.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    dosage = map["dosage"];
    when = stringWhen[map["when"]]!;
    med = stringMed[map["med"]]!;
    time = map["time"];
    done = map["done"];
    id = map["id"];
  }
}

class AppModel extends ChangeNotifier {
  List<Medication> _items = [];
  final _db = Localstore.instance;

  UnmodifiableListView<Medication> get meds => UnmodifiableListView(_items);
  int get doneMedCount => _items.where((element) => element.done).length;
  int get notDoneMedCount => _items.where((element) => !element.done).length;


  AppModel() {
    _db
        .collection("meds")
        .stream
        .map(Medication.fromMap)
        .toList()
        .then((value) => _items = value).then((_) => notifyListeners());
  }

  void setMedDone(String id) {
    _db
        .collection("meds")
        .doc(id).set({"done": true}, SetOptions(merge: true))
        .then((_) => _items = _items.map((e) {
          if (e.id == id) e.done = true;
          return e;
    }).toList()).then((_) => notifyListeners());
  }

  void removeMedication(String id) => _db
      .collection("meds")
      .doc(id)
      .delete()
      .then((_) => _items.removeWhere((element) => element.id == id))
      .then((_) => notifyListeners());

  void addMedication(Medication newMed) {
    String id = _db.collection("meds").doc().id;
    newMed.id = id;
    _db
        .collection("meds")
        .doc(id)
        .set(newMed.toMap())
        .then((_) => _items.add(newMed))
        .then((_) => notifyListeners());
  }
}
