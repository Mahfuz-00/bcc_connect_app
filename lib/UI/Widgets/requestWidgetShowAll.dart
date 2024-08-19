import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// A custom widget designed to display a list of requests or handle errors.
/// This widget supports showing loading indicators, handling errors, and displaying lists.
///
/// It does not include the "See All" button, focusing solely on displaying the request list.
class RequestsWidgetShowAll extends StatelessWidget {
  final bool loading; // Indicates whether data is currently loading.
  final bool fetch; // Indicates whether data fetching is complete.
  final String errorText; // Error message to be displayed if there's an error.
  final Future<void>
      fetchData; // Future that represents the data fetching process.
  final List<Widget>
      listWidget; // List of widgets to be displayed if data is successfully fetched.

  const RequestsWidgetShowAll({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
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
            // Display a loading indicator while data is being fetched.
            return Container(
              height: 200, // Height of the loading container.
              width: screenWidth, // Width of the loading container.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Rounded corners.
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
                    SizedBox(height: 10), // Space after the ListView.
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
}
