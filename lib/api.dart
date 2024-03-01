import 'dart:convert';
import 'package:api_practice/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class API extends StatefulWidget {
  const API({super.key});

  @override
  State<API> createState() => _APIState();
}

class _APIState extends State<API> {
 List<PhotoModel> postlist = [];
  // get api function
    Future<List<PhotoModel>> fetchPhoto () async {
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
        final data = jsonDecode(response.body);
        if(response.statusCode == 200){
           for(Map<String,dynamic> i in data){
              postlist.add(PhotoModel.fromJson(i));
           }
           return postlist;
        }
        else {
          throw 'An Unexpected Error';
        }
    }
    //post api
  // void postData() async {
  //    try {
  //    final response = await http.post(Uri.parse('https://jsonplaceholder.typicode.com/photos'),
  //    body: jsonEncode({
  //      "title": "Hello World",
  //      "Url": "https://via.placeholder.com/600/92c952",
  //       "id": 1.toString()
  //    })
     
  //    );
  //    response.body;
  //    } 
  //    catch (e){
  //     throw e.toString();
  //    }
  // }

  
//delete api  function
    void deleteData(String id) async {
  try {
        final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/photos/$id'));
       
         if(response.statusCode  == 200){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$id Deleted Successfully')));
         }
        
  } catch (e){
    throw e.toString();
  }
}
  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Api Course '),
      centerTitle: true,
      ),
    body: Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: fetchPhoto(), 
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator.adaptive(),);
              }
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              } else {
            return ListView.builder(
              itemCount: postlist.length,
              itemBuilder: (context,index){
                final photo = postlist[index].url;
                final title = postlist[index].title;
                final id = postlist[index].id;
             return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(photo.toString())),
              subtitle: Text(id.toString()),
              title: Text(title.toString()),
              trailing: IconButton(onPressed: (){
                  setState(() {
                    deleteData(id.toString());

                  });
              }, icon: const Icon(Icons.delete,color: Colors.red,)),
             );
            });
            }
          }),
        )
        
      ],
    ),
   
    );
  }
}
