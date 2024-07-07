import 'package:flutter/material.dart';
import 'package:resume_parser/database/function.dart';
import 'package:resume_parser/database/model.dart';
class ShowTextField extends StatefulWidget {
  const ShowTextField({super.key});

  @override
  State<ShowTextField> createState() => _ShowTextFieldState();
}

class _ShowTextFieldState extends State<ShowTextField> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserList,
      builder: (BuildContext context, List<User> value, Widget? child){
        return ListView.separated(
          itemBuilder: (ctx,index)
          {
            final data = value[index];
            return ListTile(
              title: Text(data.username),
              subtitle: Text(data.mail!),
              trailing: IconButton(
                onPressed: () {
                  if (data.id != null) {
                    deleteUserList(data.id!);
                  }else{
                    print("Value is null");
                  }
                },
                icon: Icon(Icons.delete_rounded,color: Colors.cyan,),
              ),
            );
          },
          separatorBuilder: (ctx,index)
          {
            return const Divider();
          },
          itemCount: value.length,
        );
      },

    );
  }
}
