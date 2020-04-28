import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //insertDog(labra);
  List li=await retrieveDogs();
  print(li[0].age);
  print(li[0].name);

  print(dd);
  print(labra.name);
  runApp(MyApp());
}
List dd=[1,2];
class Dog{
  final int id;
  final String name;
  final int age;
  Dog({this.id,this.name,this.age});
  Map<String,dynamic> tomap(){
    return{
      'id':id,
      'name':name,
      'age':age

    };
  }

}


initDb() async {
  String databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'dog_database.db');
  var database = await openDatabase(path, version: 1, onCreate: _onCreate);
  return database;

}

void _onCreate(Database db, int newVersion) async {
  await db.execute(
      "CREATE TABLE dogs(id INTEGER PRIMARY KEY,name TEXT,age INTEGER)");
}


void insertDog(Dog dog) async{
  final Database db=await initDb();
  db.insert('dogs', dog.tomap());

}

final labra=Dog(id: 1,name: 'tommy',age: 5);


Future<List<Dog>> retrieveDogs() async{
  final Database db=await initDb();
  final List<Map<String,dynamic>> maps=await db.query('dogs');
  return List.generate(maps.length, (index) {
    print(maps[index]['name']);
    return new Dog(id: maps[index]['id'],name: maps[index]['name'],age: maps[index]['age']);
  });
}

class AppHomePage extends StatefulWidget{
  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dogs List"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            DogsForm(),
            RaisedButton(
              child: Text("goto the list"),
              onPressed: (){
                Navigator.of(context).pushNamed('\doglist');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: GenerateRoutes.onGenerateRoute,
      
      home: AppHomePage(),
    );
  }
}



class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("ff"),),
      body: Center(
        child: Container(

          child: FutureBuilder(
              future: retrieveDogs(),
              builder: (context,snapshot){
                if(snapshot.data==null){
                  return Center(
                    child: Text("loading.."),
                  );
                }
                else{
                return ListView.builder(

                  itemBuilder: (context,index){

                    return ListTile(title: Text(snapshot.data[index].name),);
                  },
                  itemCount: snapshot.data.length,
                );}
              }
          ),
        )
      ),
    );
  }
}
class DogsForm extends StatefulWidget{
  _DogsFormState createState()=>_DogsFormState();
}

class _DogsFormState extends State<DogsForm>{
  final _formKey = GlobalKey<FormState>();
  final _namefieldkey=GlobalKey<FormFieldState>();
  final _agefieldkey=GlobalKey<FormFieldState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: _namefieldkey,
            initialValue: 'Enter Dogs  Name',
            validator: (value){
              if(value.isEmpty){
                return "PLease Enter Some Name For Dog";
              }
              return null;
            },
          ),
          TextFormField(
            key: _agefieldkey,
            initialValue: "Enter Dogs Age",
            validator: (value){
              if(value.isEmpty){
                return "please Enter Age Of Dog";
              }
              return null;
            },
          ),
          /*RaisedButton(onPressed: ()async{

           // print(idlist[idlist.length]);

            final currentDog=Dog(
               name: "xx",
                age: 22,
                id: 6,//idlist[idlist.length].id
            );
           print(currentDog.age);
            print(currentDog.id);
            print("dfd");
            print(idlist.last.id+1);

          })*/
          RaisedButton(
            child: Text("Submit"),
            onPressed: ()async{

              if(_formKey.currentState.validate()){
              List idlist=await retrieveDogs();
              final nextDog=Dog(
               name:_namefieldkey.currentState.value,
                age: int.parse(_agefieldkey.currentState.value),
                id: idlist.last.id+1,
                );

                 insertDog(nextDog);
              }
            },
          )

        ],
      ),
    );
  }
}

class GenerateRoutes{
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    final args=settings.arguments;
    switch(settings.name)
    {
      case 'doglist':
        return MaterialPageRoute(builder: (_)=>MyHomePage());



    }
  }
}


