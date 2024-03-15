import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:callapi/models/Rickandmorty.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Rickandmorty>? _RickMorty;

  @override
  void initState() {
    super.initState();
    _fetchRickMorty();
  }

  Future<void> _fetchRickMorty() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response =
        await dio.get('https://api.sampleapis.com/rickandmorty/characters');
    print('Status code: ${response.statusCode}');
    response.headers.forEach((name, values) {
      print('$name: $values');
    });
    print(response.data.toString());

    setState(() {
      List list = jsonDecode(response.data.toString());
      _RickMorty = list.map((item) => Rickandmorty.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick And Morty characters'),
        backgroundColor: Colors.grey.shade300, // สีเทาอ่อนๆ
      ),
      body: Column(
        children: [
          Expanded(
            child: _RickMorty == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _RickMorty!.length,
                    itemBuilder: (context, index) {
                      var RandM = _RickMorty![index];
                      return ListTile(
                        title: Text(RandM.name ?? ''),
                        subtitle: Text(RandM.type ?? ''),
                        trailing: RandM.image == ''
                            ? null
                            : Image.network(
                                RandM.image ?? '',   
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                        onTap: () {
                          _showCharacterDetails(RandM);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCharacterDetails(Rickandmorty character) {
    IconData genderIcon = character.gender == 'Female' ? Icons.female : Icons.male;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(character.name ?? ''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (character.image != null && character.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.network(
                      character.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.badge, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text('Name: ${character.name ?? ''}'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.man_4, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text('Type: ${character.type ?? ''}'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(genderIcon, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text('Gender: ${character.gender ?? ''}'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.public, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text('Origin: ${character.origin ?? ''}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
