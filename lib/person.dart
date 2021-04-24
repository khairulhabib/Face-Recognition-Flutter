import 'dart:convert';

Person personFromJson(String str){
  final jsonData = json.decode(str);
  return Person.fromMap(jsonData);
}

String personToJson(Person p){
  final d = p.toMap();
  return json.encode(d);
}

class Person {
  int id;
  String nik;
  String name;
  String embedding;

  Person({
    this.id,
    this.nik,
    this.name,
    this.embedding,
  });

  factory Person.fromMap(Map<String,dynamic> json) => new Person(
    id: json["id"],
    nik: json["nik"],
    name: json["name"],
    embedding: json["embedding"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nik": nik,
    "name": name,
    "embedding": embedding,
  };
}