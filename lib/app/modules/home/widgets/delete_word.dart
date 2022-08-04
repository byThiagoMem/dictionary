import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteWord {
  static void delete(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
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
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  'Confirma exclusão?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _button(
                        label: 'Voltar',
                        color: Colors.pink[300]?.withOpacity(.2),
                        onPressed: () => Modular.to.pop(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _button(
                        label: 'Confirmar',
                        color: const Color.fromARGB(255, 235, 129, 164),
                        onPressed: () {
                          onPressed();
                          Modular.to.pop();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _button({
  required String label,
  required VoidCallback onPressed,
  final Color? color,
  final Color? textColor = Colors.white,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: color,
      fixedSize: const Size(
        double.maxFinite,
        50,
      ),
    ),
    child: Text(
      label,
      style: GoogleFonts.comicNeue(
        color: textColor,
        fontSize: 16,
        letterSpacing: 1.5,
      ),
    ),
  );
}
