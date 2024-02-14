import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_mezgeb_bet/adminPage/AttachmentPage.dart';
import 'package:firebase_mezgeb_bet/common/AppColor.dart';
import 'package:firebase_mezgeb_bet/common/Letters.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
 * LetterManagmentPage - This class used send and reterive the letter form the backend API
 * This class have Three Methods There are:
 * _navigateToAttachmentPage: this private method used to this page goes to another pages
 *                            This method take a parameter of Letter
 * _showForm: This private method show the form when we click the add button this form contain the letter satisfy
 *
 *
* */
class LetterManagementPage extends StatefulWidget {
  @override
  _LetterManagementPageState createState() => _LetterManagementPageState();
}

class _LetterManagementPageState extends State<LetterManagementPage> {
  late String myAccessToken;
  DateTime? selectedDate;
  List<Letter> letters = [];
  final TextEditingController referenceNumber = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController urgencyController = TextEditingController();
  final TextEditingController contentSummaryController = TextEditingController();
  final TextEditingController attachmentsController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  //CollectionFunction collectionFunction = CollectionFunction();
  File? attachment;

  Object? get data => null;

  @override
  void initState() {
    super.initState();
    //myAccessToken = Provider.of<AccessTokenProvider>(context, listen: false).accessToken ?? '';
    _loadData();
  }


  int rowsPerPage = 10;
  int currentPage = 0;


  @override
  Widget build(BuildContext context) {
    List<DataRow> currentRows = _buildRows()
        .skip(currentPage * rowsPerPage)
        .take(rowsPerPage)
        .toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Letter Management System', style: TextStyle(fontSize: 20)),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            onPressed: Navigator.of(context).pop,
          ),
          elevation: 8,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.search, color: Colors.black),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                // Call the fetch data function when the text changes
                                //collectionFunction.fetchData(searchQuery: value);
                                setState(() {}); // Redraw the widget to reflect the search results
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: AppColor.yellow,
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showForm(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 20,
                  columns: _buildColumns(),
                  rows: currentRows,
                  headingRowColor: MaterialStateProperty.all(AppColor.yellow),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: currentPage > 0 ? () => _changePage(-1) : null,
                    child: Text('Previous'),
                  ),
                  TextButton(
                    onPressed: () {
                      int totalPages = (letters.length / rowsPerPage).ceil();
                      if (totalPages == 0 && letters.isNotEmpty) {
                        totalPages = 1; // Ensure at least one page if there are items in letters
                      }

                      print('Current page: $currentPage'); // Print the current page number
                      print('Total pages: $totalPages'); // Print the total number of pages
                      print('Current rows length: ${currentRows.length}'); // Print the length of current rows
                      print('Rows per page: $rowsPerPage'); // Print the rows per page value
                      _changePage(1);
                    },
                    // onPressed: currentRows.length == rowsPerPage ? () => _changePage(1) : null,

                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('Reference Number')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Sender Name')),
      DataColumn(label: Text('Organization')),
      DataColumn(label: Text('Subject')),
      DataColumn(label: Text('Urgency')),
      DataColumn(label: Text('Content Summary')),
      DataColumn(label: Text('AttachmentName')),
      DataColumn(label: Text('Assigned To')),
      DataColumn(label: Text('Created By')),
      DataColumn(label: Text('Comments')),

    ];
  }
  List<DataRow> _buildRows() {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, letters.length);

    final displayedLetters = letters.sublist(startIndex, endIndex);

    return displayedLetters.map((letter) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColor.white;
            } else {
              return AppColor.white;
            }
          },
        ),
        cells: [
          DataCell(Text(letter.referenceNumber)),
          DataCell(Text(letter.date.toString())),
          DataCell(Text(letter.senderName)),
          DataCell(Text(letter.organization)),
          DataCell(Text(letter.subject)),
          DataCell(Text(letter.urgency)),
          DataCell(Text(letter.contentSummary)),
          DataCell(Text(letter.attachments?.name ?? '')),
          DataCell(Text(letter.assignedTo)),
          DataCell(Text(letter.createdBy)),
          DataCell(Text(letter.comments)),
        ],
        onSelectChanged: (selected) {
          if (selected != null && selected) {
            _navigateToAttachmentPage(letter);
          }
        },
      );
    }).toList();
  }



  void _navigateToAttachmentPage(Letter letter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachmentPage(
            attachmentName: letter.attachments.name),
      ),
    );
  }

  Future<void> _showForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Letter'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Date'),
                _buildTextField('Reference Number'),
                _buildTextField('Sender Name'),
                _buildTextField('Organization'),
                _buildTextField('Subject'),
                _buildTextField('Urgency'),
                _buildTextField('Content Summary'),
                _buildAttachmentField(),
                _buildTextField('Assigned To'),
                _buildTextField('Comments'),
                _buildTextField('Created By')
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
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

  Widget _buildTextField(String label) {
    TextEditingController controller;

    if (label == 'Date') {
      controller = dateController;
      return TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
      );
    } else if (label == 'Reference Number') {
      controller = referenceNumber;
    } else if (label == 'Sender Name') {
      controller = senderNameController;
    } else if (label == 'Organization') {
      controller = organizationController;
    } else if (label == 'Subject') {
      controller = subjectController;
    } else if (label == 'Urgency') {
      controller = urgencyController;
    } else if (label == 'Content Summary') {
      controller = contentSummaryController;
    } else if (label == 'Assigned To') {
      controller = assignedToController;
    } else if (label == 'Comments') {
      controller = commentsController;
    } else if (label == 'Created By'){
      controller = createdByController;
    }
    else {
      // Handle other cases or set a default controller
      controller = TextEditingController();
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Widget _buildAttachmentField() {
    return ElevatedButton(
      onPressed: () => _pickAttachment(context),
      child: Text('Attachment'),
    );
  }
  //

  Future<void> _pickAttachment(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        attachment = file;
      });
    }
  }
  //


  Future<Uint8List> _readFile(File file) async {
    try {
      Uint8List bytes = await file.readAsBytes();
      return bytes;
    } catch (e) {
      print('Error reading file: $e');
      return Uint8List(0);
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_validateForm()) {
      try {
        DateTime parsedDate =
        DateFormat('MM/dd/yyyy').parse(dateController.text);
        //
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent user from dismissing the dialog
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(), // Show circular progress indicator
                  SizedBox(height: 10),
                  Text('Uploading...'), // Show text indicating file upload is in progress
                ],
              ),
            );
          },
        );

        Attachment newAttachment = Attachment(
          name: attachment != null ? attachment!.path.split('/').last : '',
          content: attachment != null ? await _readFile(attachment!) : Uint8List(0),
        );

        Letter newLetter = Letter(
          referenceNumber: referenceNumber.text,
          date: parsedDate,
          senderName: senderNameController.text,
          organization: organizationController.text,
          subject: subjectController.text,
          urgency: urgencyController.text,
          contentSummary: contentSummaryController.text,
          attachments: newAttachment,
          assignedTo: assignedToController.text,
          createdBy: createdByController.text,
          comments: commentsController.text,
        );
        print('Reference Number: ${newLetter.referenceNumber}');
        await _sendLetterDataToFirebase(newLetter);
        await _loadData();

        _clearControllers();
        Navigator.of(context).pop();
      } catch (e) {
        print('Error parsing date: $e');
      }
    } else {
      _showErrorDialog(context);
    }
  }

  Future<void> _sendLetterDataToFirebase(Letter newLetter) async {
    try {
      // Save letter data to Firestore
      await FirebaseFirestore.instance.collection('letters').add({
        'referenceNumber': newLetter.referenceNumber,
        'senderName': newLetter.senderName,
        'organization': newLetter.organization,
        'subject': newLetter.subject,
        'assignedTo': newLetter.assignedTo,
        'createdBy': newLetter.createdBy,
        'comments': newLetter.comments,
        'contentSummary': newLetter.contentSummary,
        'date': newLetter.date.toIso8601String(), // Convert DateTime to String
      });

      // Upload file attachment to Firebase Storage
      if (newLetter.attachments.content.isNotEmpty) {
        String fileName = newLetter.attachments.name;
        String filePath = 'attachments/$fileName';
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(filePath);
        await ref.putData(newLetter.attachments.content);
        String downloadURL = await ref.getDownloadURL();

        // Save attachment download URL to Firestore
        await FirebaseFirestore.instance.collection('letters').add({
          'attachmentURL': downloadURL,
        });
      }

      print('Letter successfully sent to Firebase.');
    } catch (e) {
      print('Error sending letter data to Firebase: $e');
    }
  }

// Define a global variable to keep track of the last document fetched
  DocumentSnapshot? lastDocument;

  Future<void> _loadData({int page = 1, int limit = 10}) async {
    try {
      // Fetch data from Firestore or similar database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('letters')
          .limit(limit)
          .get();

      // Process each document in the query snapshot
      List<Letter> loadedLetters = querySnapshot.docs.map((snapshot) {
        // Convert DocumentSnapshot data to a Map<String, dynamic>
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Create Letter object from data
        return Letter(
          referenceNumber: data['referenceNumber'] ?? '',
          date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          senderName: data['senderName'] as String? ?? '',
          organization: data['organization'] as String? ?? '',
          subject: data['subject'] as String? ?? '',
          urgency: data['urgency'] as String? ?? '',
          contentSummary: data['contentSummary'] as String? ?? '',
          attachments: Attachment(
            name: (data['attachments'] as Map<String, dynamic>?)?['name'] as String? ?? '',
            content: (data['attachments'] as Map<String, dynamic>?)?['content'] != null
                ? base64Decode((data['attachments'] as Map<String, dynamic>?)?['content'] as String)
                : Uint8List(0),
          ),
          assignedTo: data['assignedTo'] as String? ?? '',
          createdBy: data['createdBy'] as String? ?? '',
          comments: data['comments'] as String? ?? '',
        );
      }).toList();

      // Update state with loaded letters
      setState(() {
        letters = loadedLetters;
      });
    } catch (e) {
      print('Error fetching letters: $e');
    }
  }

  bool _validateForm() {
    return referenceNumber.text.isNotEmpty &&
        assignedToController.text.isNotEmpty &&
        commentsController.text.isNotEmpty;
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all required fields.'),
          actions: [
            TextButton(
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


  void _clearControllers() {
    dateController.clear();
    senderNameController.clear();
    organizationController.clear();
    subjectController.clear();
    urgencyController.clear();
    contentSummaryController.clear();
    attachmentsController.clear();
    assignedToController.clear();
    commentsController.clear();
    createdByController.clear();
  }

  // Future<void> _fetchData({String? searchQuery}) async {
  //  // await collectionFunction.fetchData(searchQuery: searchQuery);
  //   setState(() {
  //     letters = collectionFunction.letters;
  //   });
  // }
  void _changePage(int delta) {
    // Calculate the total number of pages
    int totalPages = ((letters.length - 1) / rowsPerPage).ceil();

    // Calculate the new page number
    int newPage = currentPage + delta;

    // Ensure that the new page number is within the valid range of pages
    if (newPage >= 0 && newPage < totalPages) {
      setState(() {
        currentPage = newPage;
      });
      _loadData(page: newPage + 1, limit: rowsPerPage).then((_) {
        // Code to execute after data is loaded
        print('Data loaded for page ${newPage + 1}');
      }).catchError((error) {
        // Handle error if _loadData fails
        print('Error loading data: $error');
      });
    }
  }



}