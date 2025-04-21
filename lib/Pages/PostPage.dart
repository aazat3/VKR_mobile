// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '/Models/PostModel/PostModel.dart';
// import '/ApiList.dart';

// class Posts extends StatefulWidget {
//   const Posts({super.key});

//   @override
//   _PostsState createState() => _PostsState();
// }

// class _PostsState extends State<Posts> {
//   List<PostBean> ?_data;

//   Future<String> getPosts() async {
//     var response =
//         await http.get(Uri.parse(APIS.postList), headers: {"Accept": "application/json"});

//     setState(() {
//       List res = json.decode(response.body);
//       _data = res.map((data) => PostBean.fromJsonMap(data)).toList();
// //      print(_data[0].body);
//     });
//     return "success";
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('POSTS'),
//       ),
//       body: ListView.builder(
//           itemCount: _data == null ? 0 : _data?.length,
//           itemBuilder: (context, index) {
//             final item = _data![index];
//             return ListTile(
//                 title: Text(
//                   item.title,
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 subtitle: Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Text(item.body,
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                 ));
//           }),
//     );
//   }
// }


