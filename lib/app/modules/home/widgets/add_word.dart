import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validatorless/validatorless.dart';

import '../../../shared/models/word_model.dart';

class AddWord {
  static void add(
    BuildContext context, {
    required Function(WordModel word) save,
    required GlobalKey<FormState> formKey,
    required TextEditingController wordController,
    required TextEditingController translationController,
    required TextEditingController pronunceController,
    required TextEditingController noteController,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          height: MediaQuery.of(context).size.height * .9,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
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
                    const SizedBox(height: 16),
                    Text(
                      'ADICIONAR',
                      style: GoogleFonts.comicNeue(
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _form(
                      controller: wordController,
                      hint: 'Palavra',
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 20),
                    _form(
                      controller: translationController,
                      hint: 'Tradução',
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 20),
                    _form(
                      controller: pronunceController,
                      hint: 'Pronúncia',
                    ),
                    const SizedBox(height: 20),
                    _form(
                      controller: noteController,
                      hint: 'Observação',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          save(
                            WordModel(
                              id: UniqueKey().toString(),
                              word: wordController.text,
                              translation: translationController.text,
                              pronunce: pronunceController.text,
                              note: noteController.text,
                            ),
                          );
                          wordController.clear();
                          translationController.clear();
                          pronunceController.clear();
                          noteController.clear();
                          Modular.to.pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.maxFinite, 50)),
                      child: Text(
                        'Salvar',
                        style: GoogleFonts.comicNeue(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _form({
  required TextEditingController controller,
  required String hint,
  int? maxLines,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines ?? 1,
    validator: validator,
    decoration: InputDecoration(
      labelText: hint,
    ),
  );
}
