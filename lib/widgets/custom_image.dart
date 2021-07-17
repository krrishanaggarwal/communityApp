import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'progress.dart';

cachedNetworkImage(String mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.fill,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(18),
      child: circularProgress(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
