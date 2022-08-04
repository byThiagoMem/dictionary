import 'package:dictionary/app/shared/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowWord {
  static void show(BuildContext context, {required WordModel word}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink[100]!.withOpacity(.5),
                  blurRadius: 20,
                  blurStyle: BlurStyle.outer,
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                height: 3,
                width: 26,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                word.word.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _content(
                title: 'TRADUÇÃO',
                content: word.translation,
              ),
              const SizedBox(height: 20),
              _content(
                title: 'PRONÚNCIA',
                content: word.pronunce,
              ),
              const SizedBox(height: 20),
              _content(
                title: 'OBSERVAÇÃO',
                content: word.note,
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}

Widget _content({
  required String title,
  required String content,
}) {
  return Column(
    children: [
      Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 3),
        color: const Color.fromARGB(255, 235, 129, 164),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        content.isNotEmpty ? content : '-',
        textAlign: TextAlign.center,
        style: GoogleFonts.comicNeue(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
