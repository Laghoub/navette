
class Navette{
  
  String titre ;
  String hubDepart;
  String hubFinale;
  String montant;
  String date ;
  int nbPackageARemettre ;
  int nbPackageARecuperer ;

  Navette({this.titre,this.hubDepart,this.hubFinale,this.montant, this.date, this.nbPackageARecuperer,
  this.nbPackageARemettre}) ;

  /*pour une utilisation de lorsqu'on appel lapi pour recuperer la listes des hubs...
  factory Navette.fromJson(Map<String, dynamic> json) {
    return Navette(
      titre: json["titre"] as String,
     
    );
  } */ 

}