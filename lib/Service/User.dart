

    

class User{
  String id;
  String nom;
  String prenom;
  String role;
  String telephone;
  bool selected = false ;

  User({this.id,this.nom,this.prenom,this.role,this.telephone});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id : json["id"],
      nom : json["nom"],
      prenom : json["prenom"],
      role : json["role"],
      telephone : json["tel"]
    );
  }

}