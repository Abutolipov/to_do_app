import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/db/notes_database.dart';
import 'package:to_do_app/screens/splash.dart';
import 'package:to_do_app/wiget/not.dart';
import '../model/note_model.dart';
import '../wiget/scroll_clock/am_pm.dart';
import '../wiget/scroll_clock/hours.dart';
import '../wiget/scroll_clock/minuts.dart';
import 'home_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final Note? note;

  const MainPage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FixedExtentScrollController _controller;




  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    _controller = FixedExtentScrollController();
  }
  int _selectedIndex = 0;
  String _time = "Not set";
  List<Widget> _pages = [
    HomePage(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  late List<Note>notes;
  bool isLoading=false;


  Future refreshNotes()async{
    setState(() {
      isLoading=false;
    });
    this.notes=await NotesDatabase.instance.readAllNotes();

    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
          onPressed: ()async{
             SharedPreferences pref=await SharedPreferences.getInstance();
             pref.remove('pass');
             pref.remove('pass2');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MyCustomWidget()));
          },
          icon: Icon(Icons.exit_to_app_outlined),
        ),
        backgroundColor: Colors.black,
        title: Text("HomePage"),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/300",
              ),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),

      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0),
              ),
            ),
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.335,
                  decoration: const BoxDecoration(
                    color: Color(0xff363636),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Add Task", style: GoogleFonts.lato(fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),),
                      SizedBox(height:15,),
                      Form(
                       key: _formKey,
                        child: NoteFormWidget(
                          isImportant: isImportant,
                          number: number,
                          title: title,
                          description: description,
                          onChangedImportant: (isImportant) =>
                              setState(() => this.isImportant = isImportant),
                          onChangedNumber: (number) => setState(() => this.number = number),
                          onChangedTitle: (title) => setState(() => this.title = title),
                          onChangedDescription: (description) =>
                              setState(() => this.description = description),
                        ),
                      ),
                      SizedBox(height:10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                        barrierColor: Color(0xff363636),
                                        context: context,
                                        builder:(context){
                                          return AlertDialog(

                                            backgroundColor: Colors.black,
                                            content :Container(
                                              padding: EdgeInsets.all(15),
                                              color: Color(0xff272727),
                                              height: 150,
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Choose time",style: TextStyle(color: Colors.white),),
                                                  Divider(thickness:2,color: Colors.white,),
                                                  SizedBox(height:15),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        color: Color(0xff272727),
                                                        height: 60,
                                                        width: 60,
                                                        child: ListWheelScrollView.useDelegate(
                                                          controller: _controller,
                                                          itemExtent:50,
                                                          perspective: 0.005,
                                                          diameterRatio: 1.2,
                                                          physics: FixedExtentScrollPhysics(),
                                                          childDelegate: ListWheelChildBuilderDelegate(
                                                            childCount: 13,
                                                            builder: (context, index) {
                                                              return MyHours(
                                                                hours: index,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        color: Color(0xff272727),
                                                        height: 60,
                                                        width: 60,
                                                        child: ListWheelScrollView.useDelegate(
                                                          itemExtent: 50,
                                                          perspective: 0.005,
                                                          diameterRatio: 1.2,
                                                          physics: FixedExtentScrollPhysics(),
                                                          childDelegate: ListWheelChildBuilderDelegate(
                                                            childCount: 60,
                                                            builder: (context, index) {
                                                              return MyMinutes(
                                                                mins: index,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),

                                                      Container(
                                                        color: Color(0xff272727),
                                                        height: 60,
                                                        width: 60,
                                                        child: ListWheelScrollView.useDelegate(
                                                          itemExtent: 50,
                                                          perspective: 0.005,
                                                          diameterRatio: 1.2,
                                                          physics: FixedExtentScrollPhysics(),
                                                          childDelegate: ListWheelChildBuilderDelegate(
                                                            childCount: 2,
                                                            builder: (context, index) {
                                                              if (index == 0) {
                                                                return AmPm(
                                                                  isItAm: true,
                                                                );
                                                              } else {
                                                                return AmPm(
                                                                  isItAm: false,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child:Text("Cancel",style: TextStyle(color: Colors.indigo),),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.indigo
                                                    ),
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child:Text("Edit"),
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                    );
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                      firstDate: DateTime.now(),
                                      confirmText: "Choose time",
                                      helpText: "",
                                      initialDatePickerMode: DatePickerMode.day,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: Colors.black,
                                              onPrimary: Colors.white,
                                              surface: Color(0xff363636),
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor: const Color(
                                                0xff363636),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Colors.indigo,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(Icons.timer,
                                    color: Colors.white.withOpacity(0.87),
                                  )),
                              SizedBox(width: 20,),
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.pin_end,
                                    color: Colors.white.withOpacity(0.87),
                                  )),
                              SizedBox(width: 20,),
                              InkWell(
                                  onTap: (){
                                    print("ishladi");
                                  },
                                  child: Icon(Icons.flag,
                                    color: Colors.white.withOpacity(0.87),
                                  )),

                            ],
                          ),
                          IconButton(
                              onPressed:addOrUpdateNote,
                              icon: Icon(
                                Icons.send, color: Color(0xff8687E7),)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Container(
            height: 72,
            width: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff8687E7),
            ),
            child: const Center(
              child: Text(
                "+",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          iconSize: 28,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.50),
          backgroundColor: Color(0xff363636),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Index',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(null),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );


  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            MainPage()), (Route<dynamic> route) => false);
      } else {
        await addNote();
      }
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          MainPage()), (Route<dynamic> route) => false);

    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}







