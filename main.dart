import 'package:flutter/material.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(TryPage());
}
class TryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MySQL Data'),
        ),
        body: MySqlData(),
      ),
    );
  }
}
class MySqlData extends StatefulWidget {
  @override
  _MySqlDataState createState() => _MySqlDataState();
}

class _MySqlDataState extends State<MySqlData> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void  _fetchData() async {
    print('Attempting to fetch data...'); // 确保这个打印语句在方法的开始处

    // 设置数据库连接参数
    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: '0000',
      databaseName: 'testdb',
    );

    await conn.connect();

    try {
      //print('Connecting to database...');
      var result = await conn.execute('SELECT name, age,gender FROM users');
      print('Query executed. Result: ${result.length} rows found.');

      // 更新UI的状态
      if (result.rows.isEmpty) {
        print('No data found in users table.');
      }
      else {
        setState(() {
          _results = result.rows.map(
                  (row) => {'name': row.colAt(0), 'gender': row.colAt(2)}//colat的參數是看select進來的參數
          ).toList(); // 假设第二列是名字，第三列是年龄
        });
      }
    }
    catch (e) {
      print('Error: $e');
    }
    finally{
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final user = _results[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text('Age1: ${user['gender']}'),
        );
      },
    );
  }
}



/*import 'package:flutter/material.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(TryPage());
}
class TryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MySQL Data'),
        ),
        body: MySqlData(),
      ),
    );
  }
}
class MySqlData extends StatefulWidget {
  @override
  _MySqlDataState createState() => _MySqlDataState();
}

class _MySqlDataState extends State<MySqlData> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void  _fetchData() async {
    print('Attempting to fetch data...'); // 确保这个打印语句在方法的开始处

    // 设置数据库连接参数
    final settings = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      password: '0000',
      db: 'testdb',
    );
    try {
      print('Connecting to database...');
      // 创建数据库连接对象
      final conn = await MySqlConnection.connect(settings);
      print('Connected to database');
      // 执行SQL查询语句
      final result = await conn.query('SELECT name, age FROM users');
      print('Query executed. Result: ${result.length} rows found.');

      //处理查询结果
      for (final row in result) {
        print('${row[0]} - ${row[1]} - ${row[2]}');
      }

      // 更新UI的状态
      if (result.isEmpty) {
        print('No data found in users table.');
      } else {
      setState(() {
        _results = result
            .map((row) => {'name': row[0], 'age': row[1]}) // 假设第二列是名字，第三列是年龄
            .toList();
      });
      }
      print('Data loaded: $_results');  // 数据加载到结果列表后打印

      // 关闭连接
      await conn.close();
    }
    catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final user = _results[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text('Age: ${user['age']}'),
        );
      },
    );
  }
}*/