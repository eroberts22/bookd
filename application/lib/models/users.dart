class BookdUser {
  final String uid;
  final String email;
  final String name;

  BookdUser(this.uid, this.email, this.name);

  Map toJson() => {
        "id": uid,
        "email": email,
        "name": name,
      };
}
