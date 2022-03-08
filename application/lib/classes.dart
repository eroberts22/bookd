class User
{
    int id = 0;
    String username = "null";
    String password = "null";

    User(this.id, this.username, this.password);

    Map toJson() =>
    {
      "id": id,
      "username": username,
      "password": password
    };
      
}


class Profile
{
    int userId = 0;
    int profType = 0;
    Map typeConfig = <String, String>{};
    String name = "null";
    String description = "null";
    String websiteLink = "null";
    int averageRating = 0;
    double latitude = 0.0;
    double longitude = 0.0;
    int travelRange = 0;
    int calendarId = 0;
    List photos = [];
    List reviews = [];

    Profile(this.userId, this.profType, this.typeConfig, this.name, this.description, this.websiteLink, this.averageRating, this.latitude, this.longitude, this.travelRange, this.calendarId, this.photos, this.reviews);

    Map toJson() => {
        "userId": userId,
        "profileType": profType,
        "typeConfig": typeConfig,
        "name": name,
        "description": description,
        "websiteLink": websiteLink,
        "average_rating": averageRating,
        "latitude": latitude,
        "longitude": longitude,
        "travelRange": travelRange,
        "calendarId": calendarId,
        "photos": photos,
        "reviews": reviews
    };
}