
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class Attachment {
  final String name;
  final Uint8List content;

  Attachment({
    required this.name,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': base64Encode(content),
    };
  }
}
class Letter {
  final String referenceNumber;
  final DateTime date;
  final String senderName;
  final String organization;
  final String subject;
  final String urgency;
  final String contentSummary;
  final Attachment attachments;
  final String assignedTo;
  final String createdBy;
  final String comments;

  Letter({
    required this.referenceNumber,
    required this.date,
    required this.senderName,
    required this.organization,
    required this.subject,
    required this.urgency,
    required this.contentSummary,
    required this.attachments,
    required this.assignedTo,
    required this.createdBy,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    // String isoDate = date.toIso8601String();
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);
    return {
      'referenceNumber': referenceNumber,
      'date': formattedDate,
      'senderName': senderName,
      'organization': organization,
      'subject': subject,
      'urgency': urgency,
      'contentSummary': contentSummary,
      'attachments': attachments.toMap(),
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'comments': comments,
    };
  }

  factory Letter.fromMap(Map<String, dynamic> map) {
    Attachment? attachments;

    try {
      if (map['attachments'] != null && map['attachments'] is Map<String, dynamic>) {
        var attachmentMap = map['attachments'] as Map<String, dynamic>;
        attachments = Attachment(
          name: attachmentMap['name'] ?? '',
          content: attachmentMap['content'] != null
              ? base64Decode(attachmentMap['content']) // Decode base64 string to Uint8List
              : Uint8List(0), // Provide default value if content is null
        );
      }
    } catch (e) {
      print('Error parsing attachment: $e');
    }
    // DateTime parsedDate;
    // try {
    //   parsedDate = DateTime.parse(map['date']);
    // } catch (e) {
    //   print('Error parsing date: $e');
    //   parsedDate = DateTime.now(); // Provide a default value if parsing fails
    // }

    return Letter(
      referenceNumber: map['referenceNumber'] ?? '',
      date:  map['date'] ?? '',
      senderName: map['senderName'] ?? '',
      organization: map['organization'] ?? '',
      subject: map['subject'] ?? '',
      urgency: map['urgency'] ?? '',
      contentSummary: map['contentSummary'] ?? '',
      attachments: attachments ?? Attachment(name: '', content: Uint8List(0)), // Provide default value if attachments is null
      assignedTo: map['assignedTo'] ?? '',
      createdBy: map['createdBy'] ?? '',
      comments: map['comments'] ?? '',
    );
  }
}