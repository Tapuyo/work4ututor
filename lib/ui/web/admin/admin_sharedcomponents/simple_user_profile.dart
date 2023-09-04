import 'package:flutter/material.dart';
import 'package:wokr4ututor/ui/web/admin/admin_models/admin_model.dart';
import 'package:wokr4ututor/ui/web/admin/helpers/app_helpers.dart';

import '../../../../constant/constant.dart';

class SimpleUserProfile extends StatelessWidget {
  const SimpleUserProfile({
    required this.name,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final AdminsInformation name;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: _buildAvatar(),
        title: _buildName(),
        trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.more_horiz),
          splashRadius: 24,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.orange.withOpacity(.2),
      child: Text(
        name.firstname.getInitialName(2).toUpperCase(),
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      "${name.firstname} ${name.lastname}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: kFontColorPallets[0],
        fontSize: 13,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
