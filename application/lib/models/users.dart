class BookdUser {
  final String uid;
  final String? email;

  BookdUser(this.uid, this.email);

  Map toJson() => {
        "id": uid,
        "email": email
      };
}
