class User {
  late String name;
  late String orgName;
  late int mobileNo;
  late String connectionType;
  late String applicationId;
  late String address;
  late String requestDetails;
  late String linkCapacity;
  bool isExpanded;

  User({
    required this.name,
    required this.orgName,
    required this.mobileNo,
    required this.connectionType,
    required this.applicationId,
    required this.address,
    required this.requestDetails,
    required this.linkCapacity,
    this.isExpanded = false,
  });
}