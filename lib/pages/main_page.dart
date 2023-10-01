import 'dart:io';

import 'package:contactlistapp/model/person_model.dart';
import 'package:contactlistapp/repositories/person_hive_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'person_detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PersonHiveRepository personHiveRepository;
  var _persons = const <PersonModel>[];
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController photoPathController = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    personHiveRepository = await PersonHiveRepository.load();
    _persons = await personHiveRepository.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
      ),
      floatingActionButton: FloatingActionButton(
          child: const FaIcon(FontAwesomeIcons.plus),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const PersonDetailPage(
                          newContact: true,
                        ))));
            loadData();
            setState(() {});
          }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: _persons.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var person = _persons[index];
                      return ListTile(
                        title: InkWell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue, // Cor da borda
                                        width: 2.0, // Espessura da borda
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: ClipOval(
                                      child: person.photoPath == ""
                                          ? const Icon(
                                              Icons.person,
                                              color: Colors.blue,
                                            )
                                          : Image.file(File(person.photoPath),
                                              fit: BoxFit.cover),
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text("${person.firstName} ${person.lastName}")
                              ]),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => PersonDetailPage(
                                          personDetail: person,
                                          newContact: false,
                                        ))));
                            loadData();
                            setState(() {});
                          },
                        ),
                      );
                    }))
          ],
        ),
      ),
    ));
  }
}
