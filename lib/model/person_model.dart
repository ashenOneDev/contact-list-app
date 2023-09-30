import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 0)
class PersonModel extends HiveObject {
  @HiveField(0)
  String firstName = "";
  @HiveField(1)
  String lastName = "";
  @HiveField(2)
  String phone = "";
  @HiveField(3)
  String photoPath = "";

  PersonModel();

  PersonModel.criar(this.firstName, this.lastName, this.phone, this.photoPath);
}
