class UserModel{
  String? id;
  String? Username;
  String? Email;

  UserModel({this.id,this.Email,this.Username});

  static UserModel fromMap(Map<String,dynamic>map){
    return UserModel(
      id: map['id'],
      Username: map['Username'],
      Email: map['Email'],
    );
  }

  Map<String,dynamic> tojson(){
    return {
      'id': id,
      'Username': Username,
      'Email': Email,
    };
  }

  // static UserModel fromJson(Map<String,dynamic> json){
  //   UserModel(
  //     id: json['id'],
  //     Username: json['Username'],
  //     Email: json['Email']); 
  // }
}