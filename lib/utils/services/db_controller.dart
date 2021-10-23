import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_notekeeper/models/helpers/uritype.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/models/link.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  _init() async {
    return openDatabase(join(await getDatabasesPath(), 'lectures.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE lecture(id INTEGER PRIMARY KEY, name TEXT, address TEXT, tutorium_address TEXT, custom_notes TEXT)');
      db.execute(
          'CREATE TABLE link(id INTEGER PRIMARY KEY, lecture INTEGER, name TEXT, type TEXT, link TEXT, uritype INTEGER, extra TEXT, FOREIGN KEY(lecture) REFERENCES lecture(id))');

      db.execute(
          "INSERT INTO lecture (id, name, address) VALUES (0, 'Formal Grammars 101', 'University of Arizona');");
      db.execute('''
      INSERT INTO link (lecture, name, type, link, uritype) VALUES
        (0, 'Noam Chomsky','Professor', 'chomsky@example.com', 0),
        (0, 'youtube channel','Online Classroom', 'youtube.com', 1),
        (0, 'discord group ChomskyFTW', 'Community', '', 1);
      ''');
    }, onUpgrade: (db, versionOld, versionNew) {
      db.execute("ALTER TABLE link ADD COLUMN extra TEXT;");
    }, version: 5);
  }

  Future<void> saveLecture(Lecture lecture) async {
    if (lecture.dbId == null) {
      lecture.dbId = await _insertLecture(lecture);
    } else {
      _updateLecture(lecture);
    }
    for (Link each in lecture.links.values) {
      if (each.name.isEmpty) continue;
      if (each.dbId == null) {
        _insertLink(each, lecture.dbId!);
      } else {
        _updateLink(each);
      }
    }
  }

  Future<void> deleteLecture(int id) async {
    final db = await database;

    await db.delete('link', where: 'lecture = ?', whereArgs: [id]);
    await db.delete('lecture', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map> loadLectures() async {
    final db = await database;
    final List<Map<String, dynamic>> lectureMaps = await db.query('lecture');

    final lectures = {
      for (Map lmap in lectureMaps)
        lmap['id']: Lecture(lmap['name'],
            dbId: lmap['id'],
            address: lmap['address'] ?? '',
            tutoriumAddress: lmap['tutorium_address'] ?? '',
            customNotes: lmap['custom_notes'] ?? '')
    };

    for (Lecture lecture in lectures.values) {
      Map links = await _loadLinks(lecture);
      links.forEach((key, value) => lecture.links[key] = value);
    }
    return lectures;
  }

  Future<Map> _loadLinks(Lecture lecture) async {
    final db = await database;
    final List<Map<String, dynamic>> links =
        await db.query('link', where: 'lecture = ?', whereArgs: [lecture.dbId]);

    return {
      for (var each in links)
        each['type']: Link(each['name'] ?? '', each['type'],
            link: each['link'],
            dbId: each['id'],
            uritype: URItype.values[each['uritype']],
            extra: each['extra'] ?? '')
    };
  }

  Future<int> _insertLecture(Lecture lecture) async {
    final db = await database;
    return await db.rawInsert(
        "INSERT INTO lecture('name', 'address', 'tutorium_address', 'custom_notes') VALUES ('${lecture.name}', '${lecture.address}', '${lecture.tutoriumAddress}', '${lecture.customNotes}')");
  }

  Future<void> _updateLecture(Lecture lecture) async {
    final db = await database;
    if (lecture.dbId == null) {
      throw Exception("Trying to sql update lecture that does not have id");
    }
    Map<String, dynamic> lm = lecture.toMap();
    await db.update('lecture', lm, where: 'id = ?', whereArgs: [lm['id']]);
  }

  Future<int> _insertLink(Link link, int lectureId) async {
    final db = await database;
    Map<String, dynamic> lm = link.toMap();
    lm['lecture'] = lectureId;

    return await db.rawInsert(
        "INSERT INTO link('lecture','name', 'type', 'link', 'uritype', 'extra') VALUES ($lectureId, '${link.name}', '${link.type}', '${link.link}', ${link.uritype.index}, ${link.extra})");
  }

  Future<void> _updateLink(Link link) async {
    final db = await database;
    if (link.dbId == null) {
      throw Exception("Trying to sql update link that does not have id");
    }
    Map<String, dynamic> lm = link.toMap();
    await db.update('link', lm, where: 'id = ?', whereArgs: [lm['id']]);
  }
}
