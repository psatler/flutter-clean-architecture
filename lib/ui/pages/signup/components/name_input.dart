import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusScope.of(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      keyboardType: TextInputType.name,
      onEditingComplete: () => focusNode.nextFocus(),
    );
  }
}
