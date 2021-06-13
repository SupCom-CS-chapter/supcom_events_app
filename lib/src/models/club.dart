
class Club {
  String id;
  String name;
  String alias;
  String logo;
  String description;

  Club({this.id, this.name, this.description, this.alias, this.logo}); // add logo

  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'logo': logo,
      'description': description,
    };
  }

  factory Club.fromMap(Map map) {
    return Club(
      id: map['id'],
      name: map['name'],
      alias: map['alias'],
      logo: map['logo'],
      description: map['description'],
    );
  }

}

//All clubs that i am aware of (hard coded for now)
//  List<Club> clubs = [
//     Club(name: "IEEE", alias: "IEEE",  logo: "ieee.jpeg", description: ""),
//     Club(name: "IEEE CS Chapter", alias: "CS",    logo: "cs.png", description: ""),
//     Club(name: "IEEE GRSS Chapter", alias: "GRSS", logo: "grss.jpg", description: ""),
//     Club(name: "IEEE RAS Chapter", alias: "RAS", logo: "ras.png", description: ""),
//     Club(name: "IEEE WIE Chapter", alias: "WIE", logo: "wie.png", description: ""),
//     Club(name: "Team", alias: "Team", logo: "team.jpg", description: ""),
//     Club(name: "NATEG", alias: "NATEG", logo: "nateg.png", description: ""),
//     Club(name: "ENACTUS", alias: "ENACTUS", logo: "enactus.png", description: ""),
//     Club(name: "Google Developper Student Club", alias: "DSC", logo: "dsc.png", description: ""),
//     Club(name: "Leading", alias: "Leading", logo: "leading.png", description: ""),
//     Club(name: "Alliance4AI", alias: "Allinace4AI", logo: "alliance4ai.png", description: ""),
//     Club(name: "Junior Enterprise", alias: "Junior", logo: "junior.png", description: ""),
//     Club(name: "Association of Coding Masters", alias: "ACM", logo: "acm.jpg", description: ""),
//     Club(name: "CyberSecurity", alias: "CyberSecurity", logo: "cybersecurity.png", description: ""),
//     Club(name: "SupChess", alias: "SupChess", logo: "supchess.png", description: ""),
//     Club(name: "SupMusic", alias: "SupMusic", logo: "supmusic.png", description: ""),
//     Club(name: "SupFit", alias: "SupFit", logo: "supfit.png", description: ""),
//     Club(name: "SupBasket", alias: "SupBasket", logo: "supbasket.jpg", description: ""),
//   ];