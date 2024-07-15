import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

class RequestsWidget extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void> fetchData;
  final List<Widget> listWidget;
  final bool showSeeAllButton;
  final String seeAllButtonText;
  final Widget nextPage;

  const RequestsWidget({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
    required this.showSeeAllButton,
    required this.seeAllButtonText,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FutureBuilder<void>(
        future: loading ? null : fetchData,
        builder: (context, snapshot) {
          if (!fetch) {
            // Return a loading indicator while waiting for data
            return Container(
              height: 200, // Adjust height as needed
              width: screenWidth, // Adjust width as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle errors
            return buildNoRequestsWidget(screenWidth, 'Error: $errorText');
          } else if (fetch) {
            if (listWidget.isEmpty) {
              // Handle the case when there are no pending connection requests
              return buildNoRequestsWidget(screenWidth, errorText);
            } else if (listWidget.isNotEmpty) {
              // If data is loaded successfully, display the ListView
              return Container(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listWidget.length,
                      itemBuilder: (context, index) {
                        // Display each connection request using the listWidget
                        return listWidget[index];
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    ),
                    SizedBox(height: 10),
                    if (showSeeAllButton)
                      buildSeeAllButton(context),
                  ],
                ),
              );
            }
          }
          return SizedBox(); // Return a default widget if none of the conditions above are met
        },
      ),
    );
  }

  Widget buildSeeAllButton(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.7,
              MediaQuery.of(context).size.height * 0.08,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
          },
          child: Text(
            seeAllButtonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
      ),
    );
  }
}
