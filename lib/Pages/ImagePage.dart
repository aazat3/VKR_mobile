// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '/Models/ImageModel/ImageModel.dart';
// import '/ApiList.dart';


// class Images extends StatefulWidget {
//   const Images({super.key});

//   @override
//   _ImagesState createState() => _ImagesState();
// }

// class _ImagesState extends State<Images> {
//   List<PhotosBean> ?_data;

//   Future<String> getPhotos() async {
//     var response = await http
//         .get(Uri.parse(APIS.photosList), headers: {"Accept": "application/json"});

//     setState(() {
//       List res = json.decode(response.body);
//       _data = res.map((data) => PhotosBean.fromJsonMap(data)).toList();
//     });
//     return "success";
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPhotos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('IMAGES'),
//       ),
//       body: GridView.count(
//         crossAxisCount: 3,
//         children: List.generate(_data == null ? 0 : _data!.length, (index) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(2),
//               child: Image.network(_data![index].thumbnailUrl),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
