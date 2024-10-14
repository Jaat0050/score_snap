import 'package:flutter/material.dart';
import 'package:score_snap/scanner_screen.dart';
import 'package:score_snap/helper_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController admissionNumberController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController subjectCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Basic Info', style: TextStyle(color: Colors.white))),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Student Name'),
                const SizedBox(height: 10),
                TextField(
                  controller: studentNameController,
                  decoration: InputDecoration(
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 45),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Admission Number'),
                const SizedBox(height: 10),
                TextField(
                  controller: admissionNumberController,
                  decoration: InputDecoration(
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 45),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                const Text('Teacher Name'),
                const SizedBox(height: 10),
                TextField(
                  controller: teacherNameController,
                  decoration: InputDecoration(
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 45),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Subject'),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 45),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Subject Code'),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectCodeController,
                  decoration: InputDecoration(
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 45),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (studentNameController.text.isEmpty) {
                        showToast('Enter Student Name');
                        return;
                      }
                      if (admissionNumberController.text.isEmpty) {
                        showToast('Enter Admission Number');
                        return;
                      }
                      if (subjectController.text.isEmpty) {
                        showToast('Enter SubjecT');
                        return;
                      }
                      if (subjectCodeController.text.isEmpty) {
                        showToast('Enter Subject Code');
                        return;
                      }
                      if (teacherNameController.text.isEmpty) {
                        showToast('Enter Teacher Name');
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OmrScannerScreen(
                            admissionNumber: admissionNumberController.text,
                            studentName: studentNameController.text,
                            subject: subjectController.text,
                            subjectCode: subjectCodeController.text,
                            teacherName: teacherNameController.text,
                          ),
                        ),
                      ).then((value) {
                        if (value == 1) {
                          admissionNumberController.clear();
                          studentNameController.clear();
                          subjectCodeController.clear();
                          teacherNameController.clear();
                          subjectController.clear();
                        }
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('Next', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
