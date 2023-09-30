import 'package:contactlistapp/model/person_model.dart';
import 'package:hive/hive.dart';

class PersonHiveRepository {
  static late Box _box;

  PersonHiveRepository._criar();

  static Future<PersonHiveRepository> load() async {
    if (Hive.isBoxOpen("person")) {
      _box = Hive.box("person");
    } else {
      _box = await Hive.openBox("person");
    }
    return PersonHiveRepository._criar();
  }

  save(PersonModel personModel) {
    _box.add(personModel);
  }

  update(PersonModel personModel) {
    personModel.save();
  }

  remove(PersonModel personModel) {
    personModel.delete();
  }

  List<PersonModel> getData() {
    return _box.values.cast<PersonModel>().toList();
  }
}
