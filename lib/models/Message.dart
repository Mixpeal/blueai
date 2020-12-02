class Message {
  int id;
  String hash;
  String body;
  int author;
  int status;
  int deleted;
  String date;

  Message(this.id, this.hash, this.body, this.author, this.status, this.deleted,
      this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'hash': hash,
      'body': body,
      'author': author,
      'status': status,
      'deleted': deleted,
      'date': date,
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    hash = map['hash'];
    body = map['body'];
    author = map['author'];
    status = map['status'];
    deleted = map['deleted'];
    date = map['date'];
  }
}
