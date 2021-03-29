class Package {
  String id;
  String status;
  String hubDepart;
  String nomHubDepart;
  String hubArrive;
  String nomHubArrive;
  bool selected;

  Package(
      {this.id,
      this.status,
      this.hubDepart,
      this.hubArrive,
      this.nomHubDepart,
      this.nomHubArrive,
      this.selected});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json["navette"],
      status: json["type"],
      hubArrive: json["arrival_hub_id"],
      hubDepart: json["depart_hub_id"],
      nomHubDepart: json["depart_hub"],
      nomHubArrive: json["arrival_hub"],
      selected : false ,
    );
  }
}
