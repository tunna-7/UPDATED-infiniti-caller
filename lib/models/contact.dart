class Contact {
  String id;
  String firstName;
  String lastName;
  String image;
  int cellularNum;
  int homeNum;
  int workplaceNum;
  String email;
  String gender;
  String birthdate;
  bool favorite;

  Contact({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.cellularNum,
    this.homeNum,
    this.workplaceNum,
    this.email,
    this.gender,
    this.birthdate,
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'cellularNum': cellularNum,
      'homeNum': homeNum,
      'workplaceNum': workplaceNum,
      'email': email,
      'gender': gender,
      'birthdate': birthdate,
      'favorite': favorite,
    };
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    image = map['image'];
    cellularNum = map['cellularNum'];
    homeNum = map['homeNum'];
    workplaceNum = map['workplaceNum'];
    email = map['email'];
    gender = map['gender'];
    birthdate = map['birthdate'];
    favorite = map['favorite'] == 1;
  }
}
