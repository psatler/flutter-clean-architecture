import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    final focusNode = FocusScope.of(context);

    return StreamBuilder<UiError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          onChanged: presenter.validateEmail,
          keyboardType: TextInputType.emailAddress,
          onEditingComplete: () => focusNode.nextFocus(),
        );
      },
    );
  }
}
