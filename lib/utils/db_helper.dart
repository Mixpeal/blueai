import 'package:BlueAi/models/Message.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'mymessages.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE messages (id INTEGER PRIMARY KEY, hash TEXT, body TEXT,  author INTEGER, status INTEGER, deleted INTEGER, date TEXT)');
  }

  Future<Message> add(Message message) async {
    var dbClient = await db;
    message.id = await dbClient.insert('messages', message.toMap());
    return message;
  }

  updateOrCreateMany(List messages) async {
    var dbClient = await db;
    for (var msg in messages) {
      // List<Map> maps = await dbClient
      //     .query('messages', where: 'chat_id = ?', whereArgs: [msg.chat_id]);
      // if (maps.length >= 50) {
      //   await dbClient.rawDelete("DELETE FROM messages LIMIT 1");
      // }
      List<Map> checkMessage = await dbClient
          .query('messages', where: 'hash = ?', whereArgs: [msg.hash]);
      if (checkMessage.length > 0) {
        await dbClient.rawUpdate(
            'UPDATE messages SET status = ?, remoteid = ?, date = ?, deleted = ? WHERE hash = ?',
            [
              1,
              msg.id,
              msg.date,
              msg.hash,
              checkMessage[0]['deleted'] == 1 ? 1 : msg.deleted
            ]);
      } else {
        try {
          Message newmsg = Message(msg.id, msg.hash, msg.body, msg.author,
              msg.status, msg.deleted, msg.date);
          await dbClient.insert('messages', newmsg.toMap());
        } catch (e) {
          print(e);
        }
      }
    }
    return messages;
  }

  Future<List<Message>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('messages',
        columns: ['id', 'hash', 'body', 'user_id', 'chat_id', 'status']);
    List<Message> messages = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        messages.add(Message.fromMap(maps[i]));
      }
    }
    return messages;
  }

  Future<List<Message>> getChatMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('messages', orderBy: 'date ASC');
    List<Message> messages = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        if (maps[i]['deleted'] == 0) {
          messages.add(Message.fromMap(maps[i]));
        }
      }
    }
    return messages;
  }

  Future<List<Message>> formatMessages(maps) async {
    List<Message> messages = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        messages.add(Message.fromMap(maps[i]));
      }
    }
    return messages;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByHash(String hash) async {
    var dbClient = await db;
    return await dbClient.delete(
      'messages',
      where: 'hash = ?',
      whereArgs: [hash],
    );
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.delete('messages');
  }

  Future<int> update(Message message) async {
    var dbClient = await db;
    return await dbClient.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
