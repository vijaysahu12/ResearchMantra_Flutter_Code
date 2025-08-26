import 'package:flutter/material.dart';

Widget buildLoadMoreIndicator(getCommunityDataState) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    alignment: Alignment.center,
    child: getCommunityDataState.isLoadingMore
        ? const SizedBox(
            height: 20, width: 20, child: CircularProgressIndicator())
        : null, // Or text depending on the current state
  );
}