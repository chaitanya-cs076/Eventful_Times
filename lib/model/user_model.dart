class UserModel {
  String? uid;
  String? email;
  String? clubName;
  String? department;
  String? PresidentName;
  String? phoneNO;

  UserModel({
    this.uid,
    this.email,
    this.clubName,
    this.department,
    this.PresidentName,
    this.phoneNO,
  });

  // Convert a UserModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'clubName': clubName,
      'department': department,
      'PresidentName': PresidentName,
      'phoneNO': phoneNO,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      clubName: map['clubName'],
      department: map['department'],
      PresidentName: map['PresidentName'],
      phoneNO: map['phoneNO'],
    );
  }
}
