class UserBean {

  int id;
  String name;
  String username;
  String email;
  String phone;
  String website;

	UserBean.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		name = map["name"],
		username = map["username"],
		email = map["email"],
		phone = map["phone"],
		website = map["website"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['name'] = name;
		data['username'] = username;
		data['email'] = email;
		data['phone'] = phone;
		data['website'] = website;
		return data;
	}
}
