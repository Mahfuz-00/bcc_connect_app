import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
  late String name;
  late String orgName;
  late int mobileNo;
  late String connectionType;
  late String applicationId;
  late String address;
  bool isExpanded;

  User({
    required this.name,
    required this.orgName,
    required this.mobileNo,
    required this.connectionType,
    required this.applicationId,
    required this.address,
    this.isExpanded = false,
  });
}

