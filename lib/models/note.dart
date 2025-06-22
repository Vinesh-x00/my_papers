import 'package:objectbox/objectbox.dart';

/// Represent database elements on rows
@Entity()
class Note {
  @Id()
  int id = 0;
  
  String text;
  DateTime date;
  String iv;

  Note({this.id = 0, required this.text, required this.date, required this.iv});
}