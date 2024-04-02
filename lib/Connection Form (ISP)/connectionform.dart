import 'package:flutter/material.dart';

import '../ISP Dashboard/ispDashboard.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../UserType Dashboard(Demo)/DemoAppDashboard.dart';
import 'dropdownfield.dart';
import 'radiooption.dart';

class ConnectionForm extends StatefulWidget {
  const ConnectionForm({super.key});

  @override
  State<ConnectionForm> createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUnion;
  String? selectedNTTNProvider;
  String? selectedLinkCapacity;

  final Map<String, List<String>> districtOptions = {
    'Dhaka': ['Dhaka', 'Gazipur'],
    'Chattogram': ['Chattogram', 'Coxs Bazar'],
  };

  final Map<String, List<String>> upazilaOptions = {
    'Dhaka': ['Mirpur', 'Uttara'],
    'Gazipur': ['Gazipur Sadar', 'Kaliakair'],
    'Chattogram': ['Chattogram Sadar', 'Anwara'],
    'Coxs Bazar': ['Coxs Bazar Sadar', 'Ukhia'],
  };

  final Map<String, List<String>> unionOptions = {
    'Mirpur': ['Shah Ali', 'Rupnagar'],
    'Uttara': ['Uttara', 'Haji Camp'],
    'Gazipur Sadar': ['Sreepur', 'Tongi'],
    'Kaliakair': ['Kaliakair', 'Kaliganj'],
    'Chattogram Sadar': ['Anderkilla', 'Alkoron'],
    'Anwara': ['Anwara', 'Azampur'],
    'Coxs Bazar Sadar': ['Coxs Bazar', 'Lama'],
    'Ukhia': ['Ukhia', 'Whykong'],
  };

  final Map<String, List<String>> nttnProviderOptions = {
    'Shah Ali': ['Provider A', 'Provider B'],
    'Rupnagar': ['Provider C', 'Provider D'],
    'Uttara': ['Provider E', 'Provider F'],
    'Haji Camp': ['Provider G', 'Provider H'],
    'Sreepur': ['Provider I', 'Provider J'],
    'Tongi': ['Provider K', 'Provider L'],
    'Kaliakair': ['Provider M', 'Provider N'],
    'Kaliganj': ['Provider O', 'Provider P'],
    'Anderkilla': ['Provider Q', 'Provider R'],
    'Alkoron': ['Provider S', 'Provider T'],
    'Anwara': ['Provider U', 'Provider V'],
    'Azampur': ['Provider W', 'Provider X'],
    'Coxs Bazar': ['Provider Y', 'Provider Z'],
    'Lama': ['Provider AA', 'Provider BB'],
    'Ukhia': ['Provider CC', 'Provider DD'],
    'Whykong': ['Provider EE', 'Provider FF'],
  };

  final Set<String> linkCapacityOptions = {
    '1 MB', '2MB', '3MB', '4MB', '5MB'
  };

/*  String fieldOptions = '';

  List<DropdownMenuItem<String>> dropdownItems1 = [
    DropdownMenuItem(child: Text("Option 1"), value: "Option 1"),
    DropdownMenuItem(child: Text("Option 2"), value: "Option 2"),
    DropdownMenuItem(child: Text("Option 3"), value: "Option 3"),
  ];*/

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'Connection Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(25, 192, 122, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    radius: 30,
                  ),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Organization Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ISPDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Connection Request', style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default'
                  )),
                  SizedBox(height:5),
                  Text('Please fill up the form', style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'default'
                  )),
                  SizedBox(height:20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Request Type',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default'
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.025),
                    child:
                          RadioListTileGroup(
                            options: ['New Connection', 'Upgrade', 'Others'],
                            selectedOption: null,
                            onChanged: (String value) {
                              print('Selected option: $value');
                              // You can perform any other actions here based on the selected option
                            },),
                  ),
                  SizedBox(height: 20,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedDivision,
                        items: districtOptions.keys.map((String division) {
                          return DropdownMenuItem<String>(
                            value: division,
                            child: Text(division,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDivision = newValue;
                            selectedDistrict = null; // Reset district on division change
                          });
                        },
                        decoration: InputDecoration(labelText: 'Division',border: InputBorder.none,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedDistrict,
                        items: selectedDivision != null
                            ? districtOptions[selectedDivision]!.map((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),),
                          );
                        }).toList()
                            : [],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDistrict = newValue;
                            selectedUpazila = null; // Reset thana on district change
                          });
                        },
                        decoration: InputDecoration(labelText: 'District', border: InputBorder.none,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedUpazila,
                        items: selectedDistrict != null
                            ? upazilaOptions[selectedDistrict]!.map((String thana) {
                          return DropdownMenuItem<String>(
                            value: thana,
                            child: Text(thana,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),),
                          );
                        }).toList()
                            : [],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUpazila = newValue;
                            selectedUnion = null; // Reset union on thana change
                          });
                        },
                        decoration: InputDecoration(labelText: 'Upazila', border: InputBorder.none,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedUnion,
                        items: selectedUpazila != null
                            ? unionOptions[selectedUpazila]!.map((String union) {
                          return DropdownMenuItem<String>(
                            value: union,
                            child: Text(union,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),),
                          );
                        }).toList()
                            : [],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUnion = newValue;
                            selectedNTTNProvider = null;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Union', border: InputBorder.none,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedNTTNProvider,
                        items: selectedUnion != null
                            ? nttnProviderOptions[selectedUnion]!.map((String provider) {
                          return DropdownMenuItem<String>(
                            value: provider,
                            child: Text(provider,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),
                            ),
                          );
                        }).toList()
                            : [],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedNTTNProvider = newValue;
                          });
                        },
                        decoration: InputDecoration(labelText: 'NTTN Provider', border: InputBorder.none,),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.085,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedLinkCapacity,
                        items: selectedNTTNProvider != null
                            ? linkCapacityOptions.map((String capacity) {
                          return DropdownMenuItem<String>(
                            value: capacity,
                            child: Text(
                              capacity,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'default',
                              ),
                            ),
                          );
                        }).toList()
                            : [],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLinkCapacity = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Link Capacity',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  if (selectedNTTNProvider != null)
                    Text('Provider Information',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'default',
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 10,),
                  if (selectedNTTNProvider != null)
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: screenWidth*0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      height: 1.6,
                                      letterSpacing: 1.3,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Name:\n',
                                      ),
                                      TextSpan(
                                        text: 'Organization Name:\n',
                                      ),
                                      TextSpan(
                                        text: 'Mobile No:\n',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width:10),
                            Expanded(
                              child: Container(
                                height: 80,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      height: 1.6,
                                      letterSpacing: 1.3,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Md. Samsul Islam\n',
                                      ),
                                      TextSpan(
                                        text: '$selectedNTTNProvider\n',
                                      ),
                                      TextSpan(
                                        text: '23456432109\n',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 15,),
                  Container(
                    width: screenWidth*0.9,
                    height: 120,
                    child: TextFormField(
                      enabled: selectedNTTNProvider != null,
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Remarks',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 145),
                        border:  const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width* 0.9, MediaQuery.of(context).size.height * 0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: selectedNTTNProvider != null
                            ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ISPDashboard()));
                        }
                            : null,
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color.fromRGBO(25, 192, 122, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BCCMainDashboard()));
              },
              child: Container(
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){},
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
