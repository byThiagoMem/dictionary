import 'package:dictionary/app/modules/home/cubit/home_state.dart';
import 'package:dictionary/app/modules/home/widgets/add_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components/custom_loading.dart';
import 'cubit/home_cubit.dart';
import 'widgets/delete_word.dart';
import 'widgets/show_word.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _cubit;
  late TextEditingController _wordController;
  late TextEditingController _addWordController;
  late TextEditingController _addTranslationController;
  late TextEditingController _addPronunceController;
  late TextEditingController _addNoteController;

  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _cubit = Modular.get()..getWords();
    _wordController = TextEditingController();
    _addWordController = TextEditingController();
    _addTranslationController = TextEditingController();
    _addPronunceController = TextEditingController();
    _addNoteController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        bloc: _cubit,
        listener: (_, state) {
          if (state.success.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 800),
                backgroundColor: Colors.green[300],
                content: Text(
                  state.success,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          }
        },
        builder: (_, state) {
          if (state.isLoading) {
            if (state.isLoading) {
              return const Center(
                child: CustomLoading(),
              );
            }
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 90,
                toolbarHeight: 90,
                title: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: _wordController,
                    onChanged: (word) {
                      _cubit.filterWordsByName(word);
                    },
                    decoration: InputDecoration(
                      labelText: 'Pesquisar',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.pink[200],
                      ),
                    ),
                  ),
                ),
              ),
              SliverVisibility(
                visible: state.data.isNotEmpty,
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: MediaQuery.of(context).size.height * .12,
                    ),
                    child: Column(
                      children: (state.data
                          .map(
                            (word) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    word.word,
                                    style: GoogleFonts.comicNeue(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    splashRadius: 10,
                                    splashColor: Colors.grey,
                                    onPressed: () => DeleteWord.delete(
                                      context,
                                      onPressed: () => _cubit.deleteWord(
                                        word: word,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.pink[100],
                                    ),
                                  ),
                                  onTap: () => ShowWord.show(
                                    context,
                                    word: word,
                                  ),
                                ),
                                const Divider(height: double.minPositive),
                              ],
                            ),
                          )
                          .toList()),
                    ),
                  ),
                ),
                replacementSliver: SliverToBoxAdapter(
                  child: Text(
                    'Nenhuma palavra encontrada!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          AddWord.add(
            context,
            formKey: _formKey,
            wordController: _addWordController,
            translationController: _addTranslationController,
            pronunceController: _addPronunceController,
            noteController: _addNoteController,
            save: (word) => _cubit.saveWord(word: word),
          );
        },
      ),
    );
  }
}
