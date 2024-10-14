import 'package:gsheets/gsheets.dart';

class SheetApi {
  static const credentials = r'''

''';
  static const spreadSheetId = '';

  static final gSheets = GSheets(credentials);
  static Worksheet? firstSheet;

  static Future init() async {
    try {
      final spreadSheet = await gSheets.spreadsheet(spreadSheetId);
      firstSheet = await getWorkSheet(spreadSheet, title: 'Sheet1');

      final firstRow = SheetFields.getFields();
      firstSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future sheetInsert(List<Map<String, dynamic>> rowList) async {
    if (firstSheet == null) return;
    firstSheet!.values.map.appendRows(rowList);
  }
}

class SheetFields {
  static const String studentName = 'Student Name';
  static const String admissionNumber = 'Admission Number';
  static const String subject = 'Subject';
  static const String subjectCode = 'Subject Code';
  static const String teacherName = 'Teacher Name';
  static const String totalMarks = 'Total Marks';

  static List<String> getFields() => [studentName, admissionNumber, subject, subjectCode, teacherName, totalMarks];
}

class DataOfSheet {
  final String studentName;
  final String admissionNumber;
  final String subject;
  final String subjectCode;
  final String teacherName;
  final String totalMarks;

  const DataOfSheet({
    required this.admissionNumber,
    required this.studentName,
    required this.subject,
    required this.subjectCode,
    required this.teacherName,
    required this.totalMarks,
  });

  Map<String, dynamic> toJson() => {
        SheetFields.studentName: studentName,
        SheetFields.admissionNumber: admissionNumber,
        SheetFields.subject: subject,
        SheetFields.subjectCode: subjectCode,
        SheetFields.teacherName: teacherName,
        SheetFields.totalMarks: totalMarks,
      };
}
