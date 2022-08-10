// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../providers/validator.dart';
// import 'widgets.dart';

// class ProfileForm extends StatelessWidget with Validator {
//   ProfileForm({Key? key}) : super(key: key);

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           CustomTextFormField(
//             textLabel: 'Customer Name',
//             textInputType: TextInputType.name,
//             validate: validateCustomerName,
//             onChanged: (value) {},
//             tex
//           ),
//           const SizedBox(
//             height: 6.0,
//           ),
//           CustomTextFormField(
//             textLabel: 'Speed',
//             textInputType: TextInputType.number,
//             validate: validateSpeed,
//             onChanged: (value) {},
//           ),
//           const SizedBox(
//             height: 6.0,
//           ),
//           CustomTextFormField(
//             textLabel: 'Amount',
//             textInputType: const TextInputType.numberWithOptions(decimal: true),
//             validate: validateAmount,
//             onChanged: (value) {},
//           ),
//           const SizedBox(
//             height: 6.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               OutlinedButton(
//                 onPressed: () {},
//                 child: Text('OK'),
//               ),
//               TextButton(
//                   onPressed: () {
//                     GoRouter.of(context).pop();
//                   },
//                   child: Text('CANCEL'))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
