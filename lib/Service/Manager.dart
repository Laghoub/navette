
class Manager{
  String id;
  String nom;
  String prenom;
  String mail;
  String telephone;
  bool selected = false ;

  Manager({this.id,this.nom,this.prenom,this.mail,this.telephone});

  factory Manager.fromJson(Map<String, dynamic> json){
    return Manager(
      id : json["id"],
      nom : json["nom"],
      prenom : json["prenom"],
      mail : json["mail"],
      telephone : json["tel"]
    );
  }

}