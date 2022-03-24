import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Artist {
  String userEmail = "null";
  String description = "null";
  List websiteLinks = ["null"];
  List potentialCities = ["null"];
  String stageName = "null";
  String phoneNumber = "012-345-6789";
  // Foreign key to calendar structue
  // Will need to be fleshed out later
  int calendarId = 0;
  // Photos are stored in cloud storage, and we store the url to the images here
  List photos = ["url1", "url2"];
  List reviews = [];

  Artist(
      this.userEmail,
      this.description,
      this.websiteLinks,
      this.potentialCities,
      this.stageName,
      this.phoneNumber,
      this.calendarId,
      this.photos,
      this.reviews);

  Map toJson() => {
        "userEmail": userEmail,
        "description": description,
        "websiteLinks": websiteLinks,
        "potentialCities": potentialCities,
        "stageName": stageName,
        "phoneNumber": phoneNumber,
        "calendarId": calendarId,
        "photos": photos,
        "reviews": reviews
      };
}
