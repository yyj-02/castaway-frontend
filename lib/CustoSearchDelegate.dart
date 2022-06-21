import 'dart:convert';
import 'package:flutter/material.dart';
import 'ProfileDetails.dart' as profile;
import 'Preview.dart';

class CustomSearchDelegate extends SearchDelegate {

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var fruit
        in profile.allPodcasts.map((podcast) => podcast['title']).toList()) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Previewpage(
                podcastdet: profile.allPodcasts[profile.allPodcasts
                    .map((podcast) => podcast['title'])
                    .toList()
                    .indexOf(result)]);
          })),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit
        in profile.allPodcasts.map((podcast) => podcast['title']).toList()) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Previewpage(
            podcastdet: profile.allPodcasts[profile.allPodcasts
            .map((podcast) => podcast['title'])
            .toList()
            .indexOf(result)]);
          })),
        );
      },
    );
  }
}
