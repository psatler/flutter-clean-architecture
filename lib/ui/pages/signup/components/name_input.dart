import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    final focusNode = FocusScope.of(context);

    return StreamBuilder<UiError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
          onEditingComplete: () => focusNode.nextFocus(),
        );
      },
    );
  }
}
