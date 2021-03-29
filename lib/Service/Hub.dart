class Hub{
  String id ;
  String nomVille;
  bool selected = true;

  Hub({this.id,this.nomVille,}) ;

  factory Hub.fromJson(Map<String, dynamic> json){
    return Hub(
      id : json["id"],
      nomVille : json["nomville"],
    );
  }
}