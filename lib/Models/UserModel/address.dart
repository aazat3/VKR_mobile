import '/Models/UserModel/geo.dart';

class Address {

  String street;
  String suite;
  String city;
  String zipcode;
  Geo? geo;

	Address.fromJsonMap(Map<String, dynamic> map): 
		street = map["street"],
		suite = map["suite"],
		city = map["city"],
		zipcode = map["zipcode"],
		geo = Geo.fromJsonMap(map["geo"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['street'] = street;
		data['suite'] = suite;
		data['city'] = city;
		data['zipcode'] = zipcode;
		data['geo'] = geo?.toJson();
		return data;
	}
}
