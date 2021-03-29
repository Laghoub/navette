class Enveloppe {
  String id ;
  String montant ;
  String status;
  String donneur ;
  String recepteur ;
  String hubDepart ;
  String hubArrive ;
  bool selected ;

  Enveloppe({this.id, this.montant, this.status,this.donneur,this.recepteur, this.hubArrive,this.hubDepart ,this.selected}) ;

  factory Enveloppe.fromJson(Map<String, dynamic> json) {
    return Enveloppe(
      id: json["id"],
      status: json["etat"],
      montant: json["montant"],
      donneur : json["id_donneur"] ,
      recepteur : json["id_recepteur"],
      /*hubArrive: json["arrival_hub_id"],
      hubDepart: json["depart_hub_id"],
      */selected : false ,
    );
  }
}