import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/providers/loginProvider.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:gauvigyaan/widgets/button.dart';
import 'package:gauvigyaan/widgets/date_picker.dart';
import 'package:gauvigyaan/widgets/error_utils.dart';
import 'package:gauvigyaan/widgets/image_picker.dart';
import 'package:gauvigyaan/widgets/textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/common_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLanguage = 'H';
  String _selectedCategory = 'C';
  String _selectedGender = 'M';

  String name = '';
  String fName = '';
  DateTime dob = DateTime.now();
  String mobile = '';
  String classes = '';
  String subjectID = '';
  String level = '';
  String schoolName = '';
  String school = '';
  String state = '';
  String utrNo = '';
  String city = '';
  String address = '';
  String pinCode = '';
  String? selectedClass;
  String? classError;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'S'; // Student selected by default
    context.read<LoginProvider>().getStateList();
    context.read<LoginProvider>().getClassList();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginProvider>(context);
    return Scaffold(
        appBar: AppBar(title: const Text(CommonText.register)),
        body: Container(
          margin: AppTheme.boxPadding,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTheme.verticalSpacing(),
                  // Name
                  CustomTextFormField(
                    hintText: 'Name / नाम *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter name';
                      }
                    },
                    value: name,
                    onChanged: (val) {
                      name = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  // Father's Name
                  CustomTextFormField(
                    hintText: 'Father Name / पिता का नाम *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter father name';
                      }
                    },
                    value: fName,
                    onChanged: (val) {
                      fName = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  // DOB
                  PickTimeWidget(
                    title: 'DOB / जन्म तिथि *',
                    initialValue: DateTime.now(),
                    onPickedDate: (val) {
                      dob = val;
                      setState(() {});
                    },
                    isPreviousDate: true,
                    isFutureDate: false,
                  ),
                  AppTheme.verticalSpacing(),
                  // Whatsapp No.
                  CustomTextFormField(
                    hintText: 'Whatsapp No. / व्हाट्सएप नं *',
                    length: 10,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter number';
                      }
                    },
                    value: mobile,
                    onChanged: (val) {
                      mobile = val;
                      setState(() {});
                    },
                    inputType: TextInputType.phone,
                  ),
                  AppTheme.verticalSpacing(),
                  // Exam Language
                  Text('Exam Language / परीक्षा की भाषा *',
                      style: context.textTheme.labelLarge),
                  AppTheme.verticalSpacing(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            // title: Text('Right'),
                            value: 'H',
                            groupValue: _selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value!;
                              });
                            },
                          ),
                          const Text('Hindi / हिन्दी'),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Radio(
                      //       // title: Text('Right'),
                      //       value: 'E',
                      //       groupValue: _selectedLanguage,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _selectedLanguage = value!;
                      //         });
                      //       },
                      //     ),
                      //     Text('English / अंग्रेज़ी'),
                      //   ],
                      // ),
                    ],
                  ),
                  AppTheme.verticalSpacing(),
                  // Category
                  Text('Category / वर्ग *',
                      style: context.textTheme.labelLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'S',
                            groupValue: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                          Text('Student / विद्यार्थी'),
                        ],
                      ),
                    ],
                  ),

                  AppTheme.verticalSpacing(),

                  // if (_selectedCategory == 'S') ...[
                  //   CustomDropDownButton(
                  //     label: 'कक्षा का चयन करेंं',
                  //     items: provider.groupList
                  //         .map(
                  //           (e) => e.subjectName,
                  //     )
                  //         .toList(),
                  //     onSelect: (value) {
                  //       print(value);
                  //
                  //       var data = provider.groupList
                  //           .where((element) =>
                  //           element.subjectName.contains(value))
                  //           .map((e) => e)
                  //           .toList();
                  //       print(data.first.course);
                  //       print(data.first.subjectId);
                  //       print(data.first.subjectName);
                  //       print(data.first.courseName);
                  //       classes = data.first.course;
                  //       subjectID = data.first.subjectId;
                  //       level = data.first.courseName;
                  //       setState(() {});
                  //     },
                  //   ),
                  //   AppTheme.verticalSpacing(),
                  //   Text(
                  //     level,
                  //     textAlign: TextAlign.end,
                  //     style: context.textTheme.titleSmall
                  //         ?.copyWith(color: Colors.redAccent),
                  //   ),
                  //   AppTheme.verticalSpacing(),
                  //   // City
                  //   CustomTextFormField(
                  //     hintText: 'School / College / Institute Name *',
                  //     validator: (val) {
                  //       if (val!.isNotEmpty) {
                  //         return null;
                  //       } else {
                  //         return 'Enter School / College / Institute Name';
                  //       }
                  //     },
                  //     value: schoolName,
                  //     onChanged: (val) {
                  //       schoolName = val;
                  //       setState(() {});
                  //     },
                  //   ),
                  // ],
                  // Gender
                  if (_selectedCategory == 'S') ...[
                    CustomDropDownButton(
                      label: 'कक्षा का चयन करें',
                      items: provider.groupList.map((e) => e.subjectName).toList(),
                      onSelect: (value) {
                        setState(() {
                          selectedClass = value;
                          classError = null; // clear error when user selects
                        });

                        var data = provider.groupList
                            .where((element) => element.subjectName.contains(value))
                            .toList();

                        classes = data.first.course;
                        subjectID = data.first.subjectId;
                        level = data.first.courseName;
                      },
                    ),
                    if (classError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          classError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    AppTheme.verticalSpacing(),
                    Text(
                      level,
                      textAlign: TextAlign.end,
                      style: context.textTheme.titleSmall?.copyWith(color: Colors.redAccent),
                    ),
                  ],

                  Text('Gender / लिंग *', style: context.textTheme.labelLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            // title: Text('Right'),
                            value: 'M',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          Text('Male / पुरुष'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            // title: Text('Right'),
                            value: 'F',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          Text('Female / महिला'),
                        ],
                      ),
                    ],
                  ),
                  AppTheme.verticalSpacing(),

                  // State
                  CustomDropDownButton(
                    label: 'राज्य का चयन करें',
                    items: provider.stateList
                        .map(
                          (e) => e.stateName,
                    )
                        .toList(),
                    onSelect: (value) {
                      print(value);

                      var data = provider.stateList
                          .where((element) => element.stateName.contains(value))
                          .map((e) => e)
                          .toList();
                      print(data.first.stateName);
                      print(data.first.stateId);
                      state = data.first.stateId;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  // City
                  CustomTextFormField(
                    hintText: 'City / ज़िला *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter city';
                      }
                    },
                    value: city,
                    onChanged: (val) {
                      city = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  // Complete Address

                  CustomTextFormField(
                    hintText: 'Complete Address / पूरा पता *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter address';
                      }
                    },
                    value: address,
                    onChanged: (val) {
                      address = val;
                      setState(() {});
                    },

                    // : 3,
                  ),
                  AppTheme.verticalSpacing(),
                  // Pincode
                  CustomTextFormField(
                    hintText: 'Pincode / पिन कोड *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter pincode';
                      }
                    },
                    value: pinCode,
                    onChanged: (val) {
                      pinCode = val;
                      setState(() {});
                    },
                    inputType: TextInputType.number,
                  ),
                  AppTheme.verticalSpacing(),
                  // CustomTextFormField(
                  //   hintText: 'UTR No / यूटीआर नंबर *',
                  //   validator: (val) {
                  //     if (val!.isNotEmpty) {
                  //       return null;
                  //     } else {
                  //       return 'Enter utr no';
                  //     }
                  //   },
                  //   value: utrNo,
                  //   onChanged: (val) {
                  //     utrNo = val;
                  //     setState(() {});
                  //   },
                  // ),
                  AppTheme.verticalSpacing(mul: 3),
                  // provider.userImagePath.isNotEmpty? Image.memory(provider.userImagePath):
                  // GestureDetector(
                  //   onTap: () {
                  //     pickImage(context);
                  //   },
                  //   child: Container(
                  //     height: 100,
                  //     width: 100,
                  //     decoration: BoxDecoration(color: Colors.grey.shade200),
                  //     child: provider.userImagePath.isEmpty
                  //         ? Icon(Icons.camera_alt)
                  //         : Image.memory(
                  //             base64.decode(provider.userImagePath),
                  //           ),
                  //   ),
                  // ),
                  // Submit Button
                  AppTheme.verticalSpacing(mul: 3),
                  // CustomElevatedBtn(
                  //   onPressed: () async {
                  //     // Validation
                  //     if (state.isEmpty || !_formKey.currentState!.validate()) {
                  //       if (state.isEmpty) {
                  //         ErrorUtils.showErrorSnackBar('Please Select State');
                  //       }
                  //       return;
                  //     }
                  //
                  //     try {
                  //       var res = await provider.register(
                  //         group: classes,
                  //         subjectID: subjectID,
                  //         gender: _selectedGender,
                  //         schoolName: schoolName,
                  //         name: name,
                  //         fName: fName,
                  //         dob: dob,
                  //         mobile: mobile,
                  //         category: _selectedCategory,
                  //         state: state,
                  //         address: address,
                  //         pinCode: pinCode,
                  //         language: _selectedLanguage,
                  //         utrNo: "123456",
                  //         city: city,
                  //       );
                  //
                  //       // Backend response check
                  //       if (res != null && res['Status'] == 'True') {
                  //         ErrorUtils.showSimpleInfoDialog(
                  //           context,
                  //           icon: Icons.info_outline_rounded,
                  //           color: Colors.green,
                  //           content: Text('${res['Message']}'),
                  //           onConfirm: () {
                  //             context.pop();
                  //             context.pop();
                  //           },
                  //         );
                  //       } else {
                  //         ErrorUtils.showSimpleInfoDialog(
                  //           context,
                  //           icon: Icons.info_outline_rounded,
                  //           color: Colors.red,
                  //           content: Text('${res != null ? res['Message'] : 'Server Error'}'),
                  //           onConfirm: () {},
                  //         );
                  //       }
                  //     } catch (e) {
                  //       // Catch parsing or network errors
                  //       print("Register Error: $e");
                  //       ErrorUtils.showErrorSnackBar("Something went wrong. Please try again.");
                  //     }
                  //   },
                  //   text: 'Submit',
                  // ),

                  CustomElevatedBtn(
                    onPressed: () async {
                      // Validate class selection if category is Student
                      if (_selectedCategory == 'S' && (selectedClass == null || selectedClass!.isEmpty)) {
                        setState(() {
                          classError = 'कृपया कक्षा का चयन करें';
                        });
                        return;
                      }

                      if (!_formKey.currentState!.validate() || state.isEmpty) {
                        if (state.isEmpty) {
                          ErrorUtils.showErrorSnackBar('Please Select State');
                        }
                        return;
                      }

                      try {
                        var res = await provider.register(
                          group: classes,
                          subjectID: subjectID,
                          gender: _selectedGender,
                          schoolName: schoolName,
                          name: name,
                          fName: fName,
                          dob: dob,
                          mobile: mobile,
                          category: _selectedCategory,
                          state: state,
                          address: address,
                          pinCode: pinCode,
                          language: _selectedLanguage,
                          utrNo: "123456",
                          city: city,
                        );

                        if (res != null && res['Status'] == 'True') {
                          ErrorUtils.showSimpleInfoDialog(
                            context,
                            icon: Icons.info_outline_rounded,
                            color: Colors.green,
                            content: Text('${res['Message']}'),
                            onConfirm: () {
                              context.pop();
                              context.pop();
                            },
                          );
                        } else {
                          ErrorUtils.showSimpleInfoDialog(
                            context,
                            icon: Icons.info_outline_rounded,
                            color: Colors.red,
                            content: Text('${res != null ? res['Message'] : 'Server Error'}'),
                            onConfirm: () {},
                          );
                        }
                      } catch (e) {
                        print("Register Error: $e");
                        ErrorUtils.showErrorSnackBar("Something went wrong. Please try again.");
                      }
                    },
                    text: 'Submit',
                  ),

                  AppTheme.verticalSpacing(mul: 4),
                ],
              ),
            ),
          ),
        ));
  }
}

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  void initState() {
    // TODO: implement initState

    context.read<LoginProvider>().getQRInstruction();
    context.read<LoginProvider>().getQrCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: AppTheme.boxPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Image.network(provider.qrCode),
              AppTheme.verticalSpacing(mul: 3),
              CustomElevatedBtn(
                  onPressed: () {
                    context.pushNamed(AppPages.register);
                  },
                  text: 'Go to register page'),
              AppTheme.verticalSpacing(mul: 3),
              // Container(
              //   height: 50.0 * provider.qrInstructionList.length,
              //   child: ListView.builder(
              //     itemCount: provider.qrInstructionList.length,
              //     itemBuilder: (context, index) => Text(
              //       '* ${provider.qrInstructionList[index].instruction}',
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
