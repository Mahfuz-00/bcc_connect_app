import 'package:bcc_connect_app/BCC%20Dashboard/report.dart';
import 'package:bcc_connect_app/Information/information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BCC Dashboard/bccDashboard.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/userinfocard.dart';
import '../UserType Dashboard(Demo)/DemoAppDashboard.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUnion;
  String? selectedNTTNProvider;
  String? selectedNationwide;

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

  final Map<String, List<String>> divisionOptions = {
    'Fiber@Home': ['Dhaka', 'Chattogram'],
    'Summit': ['Dhaka', 'Chattogram'],
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        titleSpacing: 5,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
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
                        builder: (context) => const BCCMainDashboard()));
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
      body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Search ISP Connection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Select an optimal filter to search ISP connection(s)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                            value: selectedNationwide,
                            items: divisionOptions.keys.map((String Nationwide) {
                              return DropdownMenuItem<String>(
                                value: Nationwide,
                                child: Text(Nationwide,
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
                                selectedNationwide = newValue;
                                selectedDivision = null; // Reset district on division change
                              });
                            },
                            decoration: InputDecoration(labelText: 'NationWide',border: InputBorder.none,),
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
                            value: selectedDivision,
                            items: selectedNationwide != null
                                ? divisionOptions[selectedNationwide]!.map((String division) {
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
                            }).toList(): [],
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
                            onPressed: selectedNationwide != null
                                ? () {

                            }
                                : null,
                            child: const Text('Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      if (selectedUnion != null)
                        Text('Connections',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'default',
                            fontWeight: FontWeight.bold,
                          ),),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          )
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
                        builder: (context) => BCCDashboard()));
              },
              child: Container(
                width: screenWidth / 2,
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
                width: screenWidth / 2,
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
