import 'dart:io';

import 'package:contactlistapp/model/person_model.dart';
import 'package:contactlistapp/repositories/person_hive_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'item1',
                  child: const Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Configurações'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext bc) {
                          return AlertDialog(
                            alignment: Alignment.centerLeft,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text(
                              "Implementação Futura",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Wrap(
                              children: [
                                Text("Em desenvolvimento!"),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Fechar")),
                            ],
                          );
                        });
                  },
                ),
                PopupMenuItem<String>(
                  value: 'item2',
                  child: const Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Sair"),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext bc) {
                          return AlertDialog(
                            alignment: Alignment.centerLeft,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text(
                              "Lista de Contatos",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Wrap(
                              children: [
                                Text("Deseja realmente sair?"),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Não")),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                  child: const Text("Sim")),
                            ],
                          );
                        });
                  },
                ),
              ];
            },
          ),
        ],
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
