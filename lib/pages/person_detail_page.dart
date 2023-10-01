import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../model/person_model.dart';
import '../repositories/person_hive_repository.dart';

class PersonDetailPage extends StatefulWidget {
  final PersonModel? personDetail;
  final bool newContact;
  const PersonDetailPage(
      {super.key, this.personDetail, required this.newContact});

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  late PersonHiveRepository personHiveRepository;
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController photoPathController = TextEditingController(text: "");
  XFile? photo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    personHiveRepository = await PersonHiveRepository.load();
    setState(() {});
    if (!widget.newContact) {
      firstNameController.text = widget.personDetail!.firstName;
      lastNameController.text = widget.personDetail!.lastName;
      phoneController.text = widget.personDetail!.phone;
      photoPathController.text = widget.personDetail!.photoPath;
    }
  }

  cropperImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      photoPathController.text = croppedFile.path;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.newContact == true ? "Novo Contato" : "Edição Contato"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  InkWell(
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Cor da borda
                            width: 2.0, // Espessura da borda
                          ),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: ClipOval(
                          child: (photo == null &&
                                  photoPathController.text == "")
                              ? const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.blue,
                                  size: 50,
                                )
                              : photoPathController.text == ""
                                  ? Image.file(File(photo!.path),
                                      fit: BoxFit.cover)
                                  : Image.file(File(photoPathController.text),
                                      fit: BoxFit.cover),
                        )),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return Wrap(
                              children: [
                                ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: const Text("Camera"),
                                    onTap: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      photo = await _picker.pickImage(
                                          source: ImageSource.camera);
                                      if (photo != null) {
                                        cropperImage(photo!);
                                      }
                                      setState(() {});
                                      Navigator.pop(context);
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_album),
                                  title: const Text("Galeria"),
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (photo != null) {
                                      cropperImage(photo!);
                                    }
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                      //final ImagePicker picker = ImagePicker();
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(children: [
                    Container(
                      width: 240,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue, // Cor da borda
                          width: 2.0, // Espessura da borda
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Borda arredondada
                      ),
                      child: TextField(
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Nome",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 240,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue, // Cor da borda
                          width: 2.0, // Espessura da borda
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Borda arredondada
                      ),
                      child: TextField(
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Sobrenome",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          )),
                    )
                  ]),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Column(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(children: [
                    Container(
                      width: 240,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue, // Cor da borda
                          width: 2.0, // Espessura da borda
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Borda arredondada
                      ),
                      child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Telefone",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          )),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !widget.newContact
                      ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext bc) {
                                  return AlertDialog(
                                    title: const Text("Alertar!"),
                                    content: const Wrap(
                                      children: [
                                        Text("Deseja realmente excluir?")
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
                                          child: const Text("Não")),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green)),
                                          onPressed: () async {
                                            await personHiveRepository
                                                .remove(widget.personDetail!);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        MainPage()))); */
                                          },
                                          child: const Text("Sim"))
                                    ],
                                  );
                                });
                          },
                          child: const Text("Excluir"))
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      onPressed: () async {
                        if (firstNameController.text.trim().length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("O nome deve ser preenchido")));
                          return;
                        }
                        if (phoneController.text.trim().length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("O telefone deve ser preenchido")));
                          return;
                        }
                        if (widget.newContact) {
                          await personHiveRepository.save(PersonModel.criar(
                              firstNameController.text,
                              lastNameController.text,
                              phoneController.text,
                              photoPathController.text));
                        } else {
                          widget.personDetail!.firstName =
                              firstNameController.text;
                          widget.personDetail!.lastName =
                              lastNameController.text;
                          widget.personDetail!.phone = phoneController.text;
                          widget.personDetail!.photoPath =
                              photoPathController.text;
                          await personHiveRepository
                              .update(widget.personDetail!);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Salvar")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
