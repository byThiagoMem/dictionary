import 'package:dictionary/app/modules/home/cubit/home_state.dart';
import 'package:dictionary/app/modules/home/widgets/add_word.dart';
import 'package:dictionary/app/modules/home/widgets/delete_word.dart';
import 'package:dictionary/app/modules/home/widgets/show_word.dart';
import 'package:dictionary/app/shared/models/notification_model.dart';
import 'package:dictionary/app/shared/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components/custom_loading.dart';
import 'cubit/home_cubit.dart';

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

  _showNotification() {
    Modular.get<NotificationService>().showNotification(
      NotificationModel(
        id: 1,
        title: 'Teste',
        body: 'Acesse o app',
        payload: '/home/',
      ),
    );
  }

  _scheduleNotification() {
    Modular.get<NotificationService>().scheduleNotification(
      NotificationModel(
        id: 1,
        title: 'Teste',
        body: 'Acesse o app',
        payload: '/home/',
      ),
    );
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
          if (state.isLoading) {
            if (state.isLoading) const CustomLoading();
          }
        },
        builder: (_, state) {
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
                  child: SizedBox(
                    height: double.maxFinite,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.data.length,
                      itemBuilder: ((context, index) {
                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.pink[100],
                          ),
                          child: ListTile(
                            title: Text(
                              state.data[index].word,
                              style: GoogleFonts.comicNeue(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                            trailing: IconButton(
                              splashRadius: 20,
                              splashColor: Colors.grey,
                              onPressed: () {
                                DeleteWord.delete(
                                  context,
                                  onPressed: () => _cubit.deleteWord(
                                    word: state.data[index],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.pink[100],
                              ),
                            ),
                            onTap: () => ShowWord.show(
                              context,
                              word: state.data[index],
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: double.minPositive,
                        );
                      },
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
