class Enveloppe {
  String id ;
  String montant ;
  String status;
  String donneur ;
  String recepteur ;
  String hubDepart ;
  String hubArrive ;
  String nomRecepteur;
  String prenomRecepteur;
  String telRecepteur ;
  String mailRecepteur ;
  bool selected ;

  Enveloppe({this.id, this.montant, this.status,this.donneur,this.recepteur, this.hubArrive,this.hubDepart,
   this.nomRecepteur,this.prenomRecepteur,this.telRecepteur, this.mailRecepteur,this.selected}) ;

  factory Enveloppe.fromJson(Map<String, dynamic> json) {
    return Enveloppe(
      id: json["id"],
      status: json["etat"],
      montant: json["montant"],
      donneur : json["id_donneur"] ,
      recepteur : json["id_recepteur"],
      hubArrive: json["hub_reception"],
      hubDepart: json["hub_donneur"],
      nomRecepteur : json["nom_recepteur"] ,
      prenomRecepteur : json["prenom_recepteur"],
      telRecepteur: json["tel_recepteur"],
      mailRecepteur: json["email_recepteur"],
      selected : false ,
    );
  }
}