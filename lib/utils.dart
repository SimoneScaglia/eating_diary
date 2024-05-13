import 'package:sqflite/sqflite.dart';

class Utils{
  static late Database db;

  static String getFormattedDate(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String getFormattedText(String input){
    String output = "";
    List<String> tokens = input.split(" ");
    for(String token in tokens){
      output += (token.length > 3) ? token[0].toUpperCase() + token.substring(1) : token;
      output += " ";
    }
    return output;
  }
}