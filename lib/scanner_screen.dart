import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:score_snap/helper_functions.dart';
import 'package:score_snap/sheet.dart';

class OmrScannerScreen extends StatefulWidget {
  String studentName;
  String admissionNumber;
  String teacherName;
  String subject;
  String subjectCode;

  OmrScannerScreen({
    super.key,
    required this.teacherName,
    required this.admissionNumber,
    required this.studentName,
    required this.subject,
    required this.subjectCode,
  });

  @override
  _OmrScannerScreenState createState() => _OmrScannerScreenState();
}

class _OmrScannerScreenState extends State<OmrScannerScreen> {
  bool isLoading = false;
  bool isButtonLoading = false;
  File? _selectedImage;
  var _result;
  List<int?> _selectedOptions = List<int?>.generate(35, (index) => null);
  double _totalMarks = 0;

  final List<String> options = ["N/A", "0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5"];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            showCropGrid: true,
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.orange.shade300,
            toolbarWidgetColor: Colors.white,
          ),
        ],
      ).then((croppedFile) {
        if (croppedFile != null) {
          setState(() {
            _selectedImage = File(croppedFile.path);
          });
          _resizeImage(_selectedImage!);
        }
      });
    }
  }

  Future<void> _resizeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      final img.Image resizedImage = img.copyResize(image, width: 800, height: 1000);
      final resizedBytes = img.encodeJpg(resizedImage);
      setState(() {
        _selectedImage = File(imageFile.path)..writeAsBytesSync(resizedBytes);
      });
    }
  }

  Future<void> _sendImageToBackend() async {
    setState(() {
      isLoading = true;
    });
    if (_selectedImage == null) {
      showToast('image not selected');
      return;
    }

    final uri = Uri.parse('https://test-py-omr-scan.onrender.com/process_omr');
    // final uri = Uri.parse('http://192.168.29.53:5000/process_omr');
    final request = http.MultipartRequest('POST', uri)..files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path)); // Send the file as 'image'

    print(uri);

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        setState(() {
          _result = json.decode(responseBody.body);
          showToast('Image processing Complete');
          print(_result);
          isLoading = false;
          _populateSelectedOptions(); // Populate the selected options
          _calculateTotalMarks(); // Calculate total marks
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast('Failed to process image ');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showToast('Error uploading image');
      print("Error uploading image: $error");
    }
  }

  void _populateSelectedOptions() {
    if (_result != null) {
      List<dynamic> questionAnswers = _result!; // The response is a list of question-answer pairs

      for (var qa in questionAnswers) {
        int questionIndex = qa['question'] - 1; // Subtract 1 to adjust to 0-indexed list
        int selectedOption = qa['answer'];

        setState(() {
          _selectedOptions[questionIndex] = selectedOption;
        });
      }
    }
  }

  void _calculateTotalMarks() {
    double total = 0;
    for (int? optionIndex in _selectedOptions) {
      if (optionIndex != null && optionIndex > 0) {
        total += double.tryParse(options[optionIndex]) ?? 0;
      }
    }
    setState(() {
      _totalMarks = total;
    });
  }

  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sheet Processing", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedImage == null ? const Center(child: Text("No image selected", style: TextStyle(fontSize: 18))) : Image.file(_selectedImage!),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showImageSourceSelector(context),
                    child: const Text("Capture Image", style: TextStyle(color: Colors.white)),
                  ),
                  if (_selectedImage != null) const SizedBox(width: 10),
                  if (_selectedImage != null)
                    ElevatedButton(
                      onPressed: isLoading ? null : _sendImageToBackend,
                      child: const Text("Process Image", style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_result != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selected Options:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            ListView.separated(
                              separatorBuilder: (context, index) => Divider(height: 15, color: Colors.orange.shade500),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 35,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Question ${index + 1}"),
                                      Text(_selectedOptions[index] != null ? options[_selectedOptions[index]!] : "N/A"),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Total Marks: $_totalMarks",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
              const SizedBox(height: 30),
              if (_selectedImage != null && _result != null)
                Center(
                  child: isButtonLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isButtonLoading = true;
                            });
                            final sheetData = DataOfSheet(
                              admissionNumber: widget.admissionNumber,
                              studentName: widget.studentName,
                              subject: widget.subject,
                              subjectCode: widget.subjectCode,
                              teacherName: widget.teacherName,
                              totalMarks: _totalMarks.toString(),
                            );

                            await SheetApi.sheetInsert([sheetData.toJson()]);
                            Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              isButtonLoading = false;
                            });
                            showToast('Data saved');
                            Navigator.of(context).pop(1);
                          },
                          child: const Text('Save Data', style: TextStyle(color: Colors.white)),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
