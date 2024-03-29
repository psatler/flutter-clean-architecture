// // the UI below is not coupled to any 3rd party library, so it only use streams
// // and need to dispose them. That's why it is a stateful widget

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../components/components.dart';

// import 'components/components.dart';
// import 'login_presenter.dart';

// class LoginPage extends StatefulWidget {
//   final LoginPresenter presenter;

//   LoginPage(this.presenter);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   void dispose() {
//     widget.presenter.dispose();

//     super.dispose();
//   }

//   void _hideKeyboard() {
//     final currentFocus = FocusScope.of(context);

//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(
//         builder: (context) {
//           widget.presenter.isLoadingStream.listen((isLoading) {
//             if (isLoading) {
//               showLoading(context);
//             } else {
//               hideLoading(context);
//             }
//           });

//           widget.presenter.mainErrorStream.listen((error) {
//             if (error != null) {
//               showErrorMessage(context: context, message: error);
//             }
//           });

//           return GestureDetector(
//             onTap: _hideKeyboard,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   LoginHeader(),
//                   Headline1(
//                     text: 'Login',
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(32),
//                     child: Provider<LoginPresenter>(
//                       create: (_) => widget.presenter,
//                       child: Form(
//                         child: Column(
//                           children: [
//                             EmailInput(),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 8.0,
//                                 bottom: 32,
//                               ),
//                               child: PasswordInput(),
//                             ),
//                             LoginButton(),
//                             FlatButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.person),
//                               label: Text('Criar conta'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
