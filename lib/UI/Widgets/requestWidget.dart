import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// A custom widget that handles the display of a list of requests or errors.
/// It supports showing loading indicators, handling errors, displaying lists,
/// and providing a "See All" button to navigate to the next page.
class RequestsWidget extends StatelessWidget {
  final bool loading; // Indicates whether data is currently loading.
  final bool fetch; // Indicates whether data fetching is complete.
  final String errorText; // Error message to be displayed if there's an error.
  final Future<void>
      fetchData; // Future that represents the data fetching process.
  final List<Widget>
      listWidget; // List of widgets to be displayed if data is successfully fetched.
  final bool
      showSeeAllButton; // Determines if the "See All" button should be shown.
  final String
      seeAllButtonText; // Text to be displayed on the "See All" button.
  final Widget
      nextPage; // Widget to navigate to when the "See All" button is pressed.

  const RequestsWidget({
    Key? key,
    required this.loading, // Required to indicate loading state.
    required this.fetch, // Required to indicate fetch completion state.
    required this.errorText, // Required to display error messages.
    required this.listWidget, // Required list of widgets to display.
    required this.fetchData, // Required future for data fetching.
    required this.showSeeAllButton, // Required to determine visibility of the "See All" button.
    required this.seeAllButtonText, // Required text for the "See All" button.
    required this.nextPage, // Required widget for navigation.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FutureBuilder<void>(
        future: loading ? null : fetchData,
        // Use null future to prevent fetching if loading.
        builder: (context, snapshot) {
          if (!fetch) {
            // Return a loading indicator while waiting for data
            return Container(
              height: 200, // Height of the loading container.
              width: screenWidth, // Width of the loading container.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child:
                    CircularProgressIndicator(), // Circular progress indicator.
              ),
            );
          } else if (snapshot.hasError) {
            // Display an error message if there's an error in fetching data.
            return buildNoRequestsWidget(screenWidth, 'Error: $errorText');
          } else if (fetch) {
            if (listWidget.isEmpty) {
              // Display a message if no requests are available.
              return buildNoRequestsWidget(screenWidth, errorText);
            } else if (listWidget.isNotEmpty) {
              // Display the list of requests if data is successfully fetched.
              return Container(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      // Shrink to fit the available space.
                      physics: NeverScrollableScrollPhysics(),
                      // Disable scrolling within this ListView.
                      itemCount: listWidget.length,
                      // Number of items in the list.
                      itemBuilder: (context, index) {
                        // Build each item in the list using the provided widgets.
                        return listWidget[index];
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10), // Space between items.
                    ),
                    SizedBox(height: 10), // Space before the "See All" button.
                    if (showSeeAllButton) // Conditionally display the "See All" button.
                      buildSeeAllButton(context),
                  ],
                ),
              );
            }
          }
          return SizedBox(); // Default widget to return if none of the conditions match.
        },
      ),
    );
  }

  // Builds and returns a "See All" button.
  Widget buildSeeAllButton(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        // Elevation for the button shadow.
        borderRadius: BorderRadius.circular(10),
        // Rounded corners for the button.
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            // Button background color.
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.7, // Width of the button.
              MediaQuery.of(context).size.height *
                  0.08, // Height of the button.
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Button corner radius.
            ),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => nextPage));
          },
          child: Text(
            seeAllButtonText, // Text displayed on the button.
            textAlign: TextAlign.center,
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
