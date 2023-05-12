import 'package:hive/hive.dart';

final _userinfo = Hive.box('userID');
 _refreshItems(){
  final data = _userinfo.keys.map((key){
    final item = _userinfo.get(key);
    return {"key": key, "name": item["name"], "quantity": item["quantity"]};
  });
}