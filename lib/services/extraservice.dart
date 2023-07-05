import 'package:filmfusion/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void pshowDialog(BuildContext context, String id, String mediaType) {
  var size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF12121C).withOpacity(0.95),
          title: SizedBox(
            width: size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Select Watchlist',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    FireBaseServices().addWatching(id, 'Watching', mediaType);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: Color(0xFF16F66A),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Watching',
                        style: TextStyle(
                          color: Color(0xFF16F66A),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    FireBaseServices().addWatching(id, 'Completed', mediaType);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF36A5D0),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Completed',
                        style: TextStyle(
                          color: Color(0xFF36A5D0),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    FireBaseServices().addWatching(id, 'On-Hold', mediaType);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.pause_rounded,
                        color: Color(0xFFD0D036),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'On Hold',
                        style: TextStyle(
                          color: Color(0xFFD0D036),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    FireBaseServices().addWatching(id, 'Dropped', mediaType);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        color: Color(0xFFD03636),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Dropped',
                        style: TextStyle(
                          color: Color(0xFFD03636),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> launchUrls(String url) async {
  final Uri url0 = Uri.parse(url);
  if (!await launchUrl(url0)) {
    throw Exception('Could not launch $url0');
  }
}
