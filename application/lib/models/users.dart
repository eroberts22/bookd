class BookdUser {
  final String uid;
  final String? email;
  final String? type;

  BookdUser(this.uid, this.email, this.type);

  Map toJson() => {"id": uid, "email": email, "type": type};
}
