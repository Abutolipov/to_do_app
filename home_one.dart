import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:to_do_app/screens/home_page.dart';
import '../db/notes_database.dart';
import 'package:intl/intl.dart';
import '../model/note_model.dart';
class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}
bool isLoading=false;
class _HomePageState extends State<HomePage> {

  late List<Note>notes;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }



  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
            ? Container(
          padding: EdgeInsets.all(18),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/home_logo.svg"),
                Text("What do you want to do today?",style:GoogleFonts.lato(color: Colors.white,fontSize:20,fontWeight:FontWeight.w400)),
                SizedBox(height:10,),
                Text("Tap + to add your tasks",style:GoogleFonts.lato(color: Colors.white,fontSize:16,fontWeight:FontWeight.w400)),

              ],
            ),
          ),
        )
            : buildNotes(),
      ),
    );
  }
  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(4),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () {

        },

        child:NoteCardWidget(note: note, index: index),
      );
    },
  );
}


final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {

    final time = DateFormat.yMMMd().format(note.createdTime);


    return Card(
      color:Color(0xff363636),
      child: Container(
        constraints: BoxConstraints(minHeight:80,maxHeight:220),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:18,),
                Text(
                  note.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:55),
                Text(
                  time,
                  style: TextStyle(color: Colors.white,fontSize:16),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:15,),
                IconButton(
                    onPressed: ()async{
                     await NotesDatabase.instance.delete(note.id!);
                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                         MainPage()), (Route<dynamic> route) => false);
                    },
                     icon:Icon(Icons.delete,color: Colors.white38,),
                ),
                SizedBox(height:15),
                IconButton(
                  onPressed: (){},
                  icon:Icon(Icons.edit,color: Colors.white38,),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

}