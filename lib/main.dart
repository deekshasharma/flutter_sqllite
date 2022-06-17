import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqllite/dog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      openDatabase(join(await getDatabasesPath(), 'doggie_database.db'),
          onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
  }, version: 1);

  //Insert a dog in the database
  Future<void> insertDog(Dog dog) async {
    final db = await database;
    await db.insert('dogs', dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Retrieve a list of dogs from the database
  Future<List<Dog>> dogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(
        maps.length,
        (i) =>
            Dog(id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']));
  }

  //Update a given dog in the database
  Future<void> updateDog(Dog dog) async {
    final db = await database;

    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  //Delete a given dog from the database
  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }

  //Calling insert operation
  Dog kumi = const Dog(id: 0, name: 'Kumi', age: 2);
  await insertDog(kumi);
  print('Inserting dog');
  //Calling read operation
  print(await (dogs()));

  //Calling update operation
  kumi = Dog(id: kumi.id, name: '${kumi.name} Kumari', age: kumi.age);
  print('Updating dog');
  await updateDog(kumi);
  //Calling read operation
  print(await (dogs()));

  //Calling delete operation
  await deleteDog(0);
  print(await (dogs()));


}
