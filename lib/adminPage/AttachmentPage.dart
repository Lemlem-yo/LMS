import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttachmentPage extends StatefulWidget {
  final String attachmentName;

  AttachmentPage({required this.attachmentName});

  @override
  _AttachmentPageState createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  String? attachmentUrl;

  @override
  void initState() {
    super.initState();
    _fetchAttachmentUrl();
  }

  Future<void> _fetchAttachmentUrl() async {
    try {
      final response = await http.get('http://192.168.100.195:3000/letters/attachments/${widget.attachmentName}' as Uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          attachmentUrl = data['url'];
        });
      } else {
        throw Exception('Failed to fetch attachment from backend');
      }
    } catch (e) {
      print('Error fetching attachment: $e');
      // Handle error
    }
  }

  late String selectedFilePath = '';
  String? selectedTeam;
  late String referenceNumber;
  late String comments;
  late String workBy;
  late DateTime selectedDate = DateTime.now();
  String? attachmentFileName;
  List<int>? fileBytes;

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String pdfApiUrl = attachmentUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Attachment Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: attachmentUrl != null
                ? _displayPDF()
                : Center(child: CircularProgressIndicator()),
          ),
          _buildChatBox(context),
        ],
      ),
    );
  }

  Widget _displayPDF() {
    return PDFView(
      filePath: attachmentUrl!,
      // Other properties...
    );
  }

  Widget _buildChatBox(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _showSuccessDialog(context);
              },
            ),
            DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  child: Text('UI Team'),
                  value: 'UI Team',
                ),
                DropdownMenuItem<String>(
                  child: Text('Backend Team'),
                  value: 'Backend Team',
                ),
                DropdownMenuItem<String>(
                  child: Text('HR'),
                  value: 'HR',
                ),
                DropdownMenuItem<String>(
                  child: Text('Finance'),
                  value: 'Finance',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTeam = value;
                });
              },
              hint: Text('To'),
              value: selectedTeam,
            ),
            IconButton(
              icon: Icon(Icons.attachment),
              onPressed: () {
                _pickFile();
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _showForm(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  void _showForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Letter Outgoing'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Reference Number'),
                onChanged: (value) {
                  referenceNumber = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Comments'),
                onChanged: (value) {
                  comments = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Work By'),
                onChanged: (value) {
                  workBy = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: dateController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitForm(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm(BuildContext context) async {
    if (_validateForm()) {
      if (selectedFilePath.isNotEmpty) {
        List<int> fileBytes = await File(selectedFilePath).readAsBytes();
        String base64File = base64Encode(fileBytes);

        var formData = {
          'referenceNumber': referenceNumber,
          'comments': comments,
          'workBy': workBy,
          'selectedTeam': selectedTeam,
          'selectedDate': selectedDate.toIso8601String(),
          'attachment': base64File,
        };

        _sendToBackend(formData);
      } else {
        _showErrorDialog(
            context, 'Please select an attachment before submitting.');
      }
    } else {
      _showErrorDialog(
          context, 'Please fill in all required fields before submitting.');
    }
  }

  void _sendToBackend(Map<String, dynamic> formData) async {
    // Retrieve the access token using AccessTokenProvider
   // AccessTokenProvider accessTokenProvider =
   // Provider.of<AccessTokenProvider>(context, listen: false);
    //String? accessToken = accessTokenProvider.accessToken;

    // Check if access token is available
    // if (accessToken == null || accessToken.isEmpty) {
    //   _showErrorDialog(context, 'Access token not available.');
    //   return;
    // }

    final Uri apiUrl =
    Uri.parse('http://192.168.100.195:3000/letters/create-outgoing');

    final http.MultipartRequest request =
    http.MultipartRequest('POST', apiUrl);

    formData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add access token to the request headers
    // request.headers['Authorization'] = 'Bearer $accessToken';

    if (fileBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'attachment',
          fileBytes!,
          filename: attachmentFileName ?? 'attachment',
          contentType: MediaType('application', 'pdf'), // Add this line
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        _showSuccessDialog(context);

        print("hi its work");
      } else {
        print('Error: ${response.reasonPhrase}');
        _showErrorDialog(context, 'Error occurred while submitting the form.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(context, 'Error occurred while submitting the form.');
    }
  }

  bool _validateForm() {
    return referenceNumber.isNotEmpty &&
        comments.isNotEmpty &&
        workBy.isNotEmpty &&
        selectedDate != null;
  }

  Future<void> _showErrorDialog(
      BuildContext context, String errorMessage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Operation successfully completed.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  void _clearForm() {
    setState(() {
      referenceNumber = '';
      comments = '';
      workBy = '';
      selectedTeam = null;
      selectedDate = DateTime.now();
      selectedFilePath = '';
    });
  }
}