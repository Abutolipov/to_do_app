import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/db/notes_database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/note_model.dart';
import 'home_page.dart';

class Detail_page extends StatefulWidget {
  final int nodeId;
  const Detail_page({Key? key, required this.nodeId}) : super(key: key);

  @override
  State<Detail_page> createState() => _Detail_pageState();
}

class _Detail_pageState extends State<Detail_page> {
  late Note note;
  late bool isLoading=false;

   String title="";
   String description="";

  @override
  void initState() {
    refresh();
    super.initState();

  }

  Future refresh()async{
    setState(() {
      isLoading=true;
    });
    this.note=await NotesDatabase.instance.readNote(widget.nodeId);

    setState(() {
       title = note.title;
       description = note.description;
    });
  }
  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon:Icon(CupertinoIcons.xmark,color: Colors.white,),
        onPressed: (){},
      ),
      actions: [
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.repeat),
        )
      ],
    ),
    body:Container(
      padding: EdgeInsets.all(18),
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  SizedBox(width:25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.length>20?title.substring(0,20):title,
                          style:GoogleFonts.lato(color: Colors.white,fontSize:20,fontWeight: FontWeight.w400)),
                      SizedBox(height: 5,),
                      Container(child: Text(description.length>20?description.substring(0,20):description,style:GoogleFonts.lato(color: Color(0xffAFAFAF),fontSize:16,fontWeight: FontWeight.w400))),
                    ],
                  ),
                ],
              ),
              IconButton(
                  onPressed:(){
                    showDialog(
                        context: context, builder: (_){
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(25.0),
                        shape:const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(10.0)),
                        ),
                        backgroundColor: Color(0xff363636),
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xff363636),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Edit Task title",style:TextStyle(color: Colors.white),),
                              Divider(thickness:1,color: Colors.white,),
                              SizedBox(height:12,),
                              buildTitle(),
                              SizedBox(height:15),
                              buildDescription(),
                            ],
                          ),
                        ),
                        actions: [
                          Container(
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: SizedBox(
                                      height:48,
                                      child: ElevatedButton(
                                          style:ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xff363636)
                                          ),
                                          onPressed:(){},
                                          child:Text("Cencel")),
                                    ),
                                ),
                                Expanded(
                                    child: SizedBox(
                                      height:48,
                                      child: ElevatedButton(
                                        style:ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff8687E7),

                                        ),
                                          onPressed:()async{
                                           await updateNote();
                                           refresh();
                                           Navigator.pop(context);
                                          },
                                          child:Text("Edit"),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          )

                        ],
                      );
                    });
                  },
               icon:Icon(Icons.edit_outlined,color: Colors.white,))
            ],
          ),
         SizedBox(height:50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timer_outlined,color: Colors.white,),
                  SizedBox(width:25,),
                  Text("Task time",style:GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w400,fontSize:16),)

                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff363636),

                ),
                  onPressed: (){

                  },
                  child:Text("To day at 16:45"),
              )
            ],
          ),
          SizedBox(height:20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.task_sharp,color: Colors.white,),
                  SizedBox(width:25,),
                  Text("Task Category",style:GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w400,fontSize:16),)

                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff363636),

                ),
                onPressed: (){

                },
                child:Text("Unversity"),
              )
            ],
          ),
          SizedBox(height:20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flag,color: Colors.white,),
                  SizedBox(width:25,),
                  Text("Task Priority",style:GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w400,fontSize:16),)

                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff363636),

                ),
                onPressed: (){

                },
                child:Text("Default"),
              )
            ],
          ),
          SizedBox(height:20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.category_sharp,color: Colors.white,),
                  SizedBox(width:25,),
                  Text("Sub-Task",style:GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w400,fontSize:16),)

                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff363636),

                ),
                onPressed: (){

                },
                child:Text("Add Sub task"),
              )
            ],
          ),
          SizedBox(height:20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.delete,color: Colors.red,),
                  SizedBox(width:20,),
                 TextButton(onPressed: (){
                   dalete();
                   Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>MainPage()));
                 }, child: Text("Delate",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w400,fontSize:18),))

                ],
              ),
            ],
          ),

        ],
      ),
    ),
  );
  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue:note.title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.w400,
      fontSize:15,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide:const  BorderSide(
          color: Colors.white,
          width:0.6,
        ),
      ),
      enabledBorder:InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
     onChanged: (titl){
      setState(() {
        this.title=titl;
      });
     },
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,

  );

  Widget buildDescription() => TextFormField(
    initialValue:note.description,
    style: TextStyle(color: Colors.white60, fontSize: 14),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.6,
        ),
      ),
      enabledBorder:InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    onChanged: (desc){
      setState(() {
       this.description=desc;
      });
    },
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
  );

  Future updateNote()async{
    final update=note.copy(
      title:title,
      description:description,
    );
    await NotesDatabase.instance.update(update);
  }

  Future dalete()async{
    await NotesDatabase.instance.delete(widget.nodeId);
  }
}
