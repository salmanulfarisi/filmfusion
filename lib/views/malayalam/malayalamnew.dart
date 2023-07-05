import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MalayalamNewMovies extends StatelessWidget {
  const MalayalamNewMovies({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_primary,
      appBar: AppBar(
        backgroundColor: background_primary,
        title: const Text(
          'Malayalam New Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerText(
              size: size,
              onTap: () {
                HapticFeedback.mediumImpact();
                GoRouter.of(context).push('/latestMalayalam');
              },
            ),
            const SizedBox(height: 10),
            ContainerText(size: size, title: 'Dubbed Movies'),
            const SizedBox(height: 10),
            ContainerText(size: size, title: "Malayalam Superhit"),
          ],
        ),
      ),
    );
  }
}

class ContainerText extends StatelessWidget {
  const ContainerText({
    super.key,
    required this.size,
    this.onTap,
    this.title = 'Latest HD Movies',
  });

  final Size size;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: accent_t.withOpacity(0.95),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
