import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/page/note/create_note_step_2.dart';
import 'package:sophia_hub/view/widget/error_dialog.dart';

class EditingNoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";

  static Route<dynamic> route(Note note) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EditingNoteDetails.view(note);
    });
  }

  static Widget view(Note note) {
    return ChangeNotifierProvider<Note>.value(
      value: note,
      child: EditingNoteDetails(),
    );
  }

  @override
  _EditingNoteDetailsState createState() => _EditingNoteDetailsState();
}

class _EditingNoteDetailsState extends State<EditingNoteDetails> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
        floatingActionButton: Consumer<NotesPublisher>(
          builder: (_, value, child) {
            return FloatingActionButton(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: Icon(value.isLoading ? Icons.refresh_rounded : Icons.done),
              onPressed: value.isLoading
                  ? null
                  : () async {
                      Result result = await value.updateNote(note);
                      if (result.isHasData) {
                        Navigator.pop(
                          context,
                        );
                      } else {
                        showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (_) {
                              return ErrorDialog(exception: result.error);
                            });
                      }
                    },
            );
          },
        ),
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            Hero(
              tag: "backButton",
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 26, right: 16, bottom: 26),
                  height: 50,
                  width: 50,
                  decoration: ShapeDecoration(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_rounded),
                  )),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: Hero(
            tag: "appBarTitle",
            child: Text(
              "${DateFormat.yMd().add_jm().format(note.timeCreated)}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<Note>(builder: (_, note, child) {
                    String status = '';
                    status = generateMoodStatus(note.emotionPoint.toInt());
                    return Container(
                      height: 120,
                      child: Stack(
                        children: [
                          Align(
                            child: Hero(
                              tag: "mood icon",
                              child: Icon(
                                generateMoodIcon(note.emotionPoint),
                                color: primary.withOpacity(0.1),
                                size: 80,
                              ),
                            ),
                            alignment: Alignment(0, -0.2),
                          ),
                          Align(
                            child: Hero(
                              tag: "mood text",
                              child: Text(
                                "$status",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                        color: primary.withOpacity(0.8),
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  SliderEmotionPoint(),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ListActivities()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Hero(
                            tag: "title",
                            child: Material(
                              child: TextFormField(
                                initialValue: note.title,
                                decoration: InputDecoration(
                                  hintText: "Tiêu đề",
                                ),
                                onChanged: (input) {
                                  note.title = input;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Hero(
                            tag: "content",
                            child: Material(
                              child: TextFormField(
                                initialValue: note.description,
                                decoration: InputDecoration(
                                    // label: Text("Nội dung",style: TextStyle(color: textColor),),
                                    hintText: "Suy nghĩ của bạn..."),
                                maxLines: 10,
                                minLines: 3,
                                onChanged: (input) {
                                  note.description = input;
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              )),
        ));
  }
}

class SliderEmotionPoint extends StatefulWidget {
  const SliderEmotionPoint({Key? key}) : super(key: key);

  @override
  _SliderEmotionPointState createState() => _SliderEmotionPointState();
}

class _SliderEmotionPointState extends State<SliderEmotionPoint> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return Slider(
      inactiveColor: Colors.grey.withOpacity(0.5),
      activeColor: Theme.of(context).colorScheme.primary,
      value: note.emotionPoint.toDouble(),
      min: 0,
      max: 10,
      divisions: 10,
      label: "${note.emotionPoint}",
      onChanged: (double value) {
        note.point = value.toInt();
      },
    );
  }
}

class ListActivities extends StatefulWidget {
  const ListActivities({Key? key}) : super(key: key);

  @override
  _ListActivitiesState createState() => _ListActivitiesState();
}

class _ListActivitiesState extends State<ListActivities> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 16,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: ShapeDecoration(
                shape: continuousRectangleBorder,
                color: Theme.of(context).colorScheme.primary),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                          value: note,
                          child: Container(
                            height: 200,
                            child: Card(
                                child: Container(
                                    height: 200, child: EmotionGrid())),
                          ));
                    });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          ...note.activities.map((e) {
            return Hero(
              tag: "emotions ${e.id}",
              child: NoteActivityIcon(e),
            );
          }).toList(),
          SizedBox(
            width: 16,
          ),
        ]),
      ),
    );
  }
}

class NoteActivityIcon extends StatefulWidget {
  final Activity e;

  const NoteActivityIcon(this.e, {Key? key}) : super(key: key);

  @override
  State<NoteActivityIcon> createState() => _NoteActivityIconState();
}

class _NoteActivityIconState extends State<NoteActivityIcon> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        child: InputChip(
          deleteIcon: Icon(
            Icons.cancel_outlined,
            color: primary.withOpacity(0.5),
          ),
          onDeleted: () {
            print('deleted');
            Provider.of<Note>(context, listen: false).removeEmotion(widget.e);
          },
          backgroundColor: Colors.white,
          avatar: Icon(
            widget.e.icon,
            color: primary,
          ),
          label: Text(
            widget.e.name ?? "NaN",
          ),
        ),
      ),
    );
  }
}
