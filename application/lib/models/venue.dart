// dont know if we need this
class Venue {
  String city = "null";
  String description = "null";
  String name = "null";
  String phoneNumber = "null";
  String streetAddress = "null";
  String zipCode = "null";
  String tags = "null";

  Venue(
    this.city, 
    this.description, 
    this.name, 
    this.phoneNumber, 
    this.streetAddress, 
    this.tags, 
    this.zipCode
  );

  Map toJson() => {
    "city":city, 
    "description":description, 
    "name":name, 
    "phoneNumber":phoneNumber, 
    "streetAddress":streetAddress, 
    "tags":tags, 
    "zipCode":zipCode
  };
}