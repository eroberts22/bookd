class User
{
    int id;
    String username;
    String password;

    User()
    {
        this.id = 0;
        this.username = "empty";
        this.password = "empty";
    }

    User(int id, String username, String password)
    {
        this.id = id;
        this.username = username;
        this.password = password;
    }

    Map toJson() =>
    {
        "id": this.id,
        "username": this.username,
        "password": this.password
    }
}


class Profile
{
    int user_id;
    int prof_type;
    Map type_config;
    String name;
    String description;
    String website_link;
    int average_rating;
    Double latitude;
    Double longitude;
    int travel_range;
    int calendar_id;
    List photos;
    List reviews;

    Profile()
    {
        this.user_id = 0;
        this.prof_type = 0;
        this.type_config = null;
        this.name = "empty";
        this.description = "empty";
        this.website_link = "empty";
        this.average_rating = 0;
        this.latitude = 0;
        this.longitude = 0;
        this.travel_range = 0;
        this.calendar_id = 0;
        this.photos = null;
        this.reviews = null;
    }

    Profile(user_id, prof_type, type_config, name, description, website_link, average_rating, latitude, longitude, travel_range, calendar_id, photos, reviews)
    {
        this.user_id = user_id;
        this.prof_type = prof_type;
        this.type_config = type_config;
        this.name = name;
        this.description = description;
        this.website_link = website_link;
        this.average_rating = average_rating;
        this.latitude = latitude;
        this.longitude = longitude;
        this.travel_range = travel_range;
        this.calendar_id = calendar_id;
        this.photos = photos;
        this.reviews = reviews;
    }

    Map toJson => {
        "user_id": this.user_id,
        "profile_type": this.prof_type,
        "type_config": this.type_config,
        "name": this.name,
        "description": this.description,
        "website_link": this.website_link,
        "average_rating": this.average_rating,
        "latitude": this.latitude,
        "longitude": this.longitude,
        "travel_range": this.travel_range,
        "calendar_id": this.calendar_id,
        "photos": this.photos,
        "reviews": this.reviews
    }
}