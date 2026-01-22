import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/common_text.dart';
import '../../providers/home_provider.dart';
import '../../providers/loginProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/date_utils.dart';
import '../../widgets/error_utils.dart';
import '../../widgets/textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLanguage = 'H';
  String _selectedCategory = 'C';
  String _selectedGender = 'M';

  // String name = '';
  // String fName = '';
  // DateTime dob = DateTime.now();
  // String mobile = '';
  String classCode = '';
  String className = '';
  String subjectID = '0';

  // String level = '';

  // String schoolName = '';
  // String school = '';
  String stateCode = '';
  String stateName = '';

  // String utrNo = '';
  String city = '';

  // String address = '';
  // String pinCode = '';

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<LoginProvider>().getUserDetails();
        await context.read<LoginProvider>().getStateList();
        context.read<LoginProvider>().getClassList();
        stateCode = context.read<HomeProvider>().userModel!.state;
        var data = context
            .read<LoginProvider>()
            .stateList
            .where((element) => element.stateId.contains(stateCode))
            .map((e) => e)
            .toList();
        stateName = data.first.stateName;
        classCode = context.read<HomeProvider>().userModel!.course;
        var subName =   context
            .read<LoginProvider>()
            .groupList
            .where((element) => element.course.contains(classCode))
            .map((e) => e)
            .toList();
        print(subName);
        className= subName.first.subjectName;
        subjectID= subName.first.subjectId;

        print(data.first.stateName);

        _selectedLanguage = context.read<HomeProvider>().userModel!.language;
        _selectedCategory = context.read<HomeProvider>().userModel!.category;
        _selectedGender = context.read<HomeProvider>().userModel!.citizen;
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginProvider>(context);
    var homeProvider = Provider.of<HomeProvider>(context);
    var user = homeProvider.userModel;
    return Scaffold(
        appBar: AppBar(title: const Text('प्रोफ़ाइल अपडेट करें')),
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
                    // key: UniqueKey(),
                    hintText: 'Name / नाम *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter name';
                      }
                    },
                    value: user!.studentName,
                    onChanged: (val) {
                      user.studentName = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),

                  // Father's Name
                  CustomTextFormField(
                    // key: UniqueKey(),
                    hintText: 'Father Name / पिता का नाम *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter father name';
                      }
                    },
                    value: user.fatherName,
                    onChanged: (val) {
                      user.fatherName = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),

                  // DOB
                  PickTimeWidget(
                    // key: UniqueKey(),
                    title: 'DOB / जन्म तिथि *',
                    initialValue: DateFormat("dd/MM/yyyy").parse(user.dob),
                    onPickedDate: (val) {
                      user.dob = DateFormat("dd/MM/yyyy").format(val);

                      setState(() {});
                    },
                    isPreviousDate: true,
                    isFutureDate: false,
                  ),
                  AppTheme.verticalSpacing(),
                  // Whatsapp No.
                  CustomTextFormField(
                    // key: UniqueKey(),
                    enabled: false,
                    hintText: 'Whatsapp No. / व्हाट्सएप नं *',
                    length: 10,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter number';
                      }
                    },
                    value: user.mobile,
                    onChanged: (val) {
                      user.mobile = val;
                      setState(() {});
                    },
                    inputType: TextInputType.phone,
                  ),
                  AppTheme.verticalSpacing(),
                  // Exam Language
                  Text('Exam Language / परीक्षा की भाषा *',
                      style: context.textTheme.labelLarge),
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
                      Row(
                        children: [
                          Radio(
                            // title: Text('Right'),
                            value: 'E',
                            groupValue: _selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value!;
                              });
                            },
                          ),
                          Text('English / अंग्रेज़ी'),
                        ],
                      ),
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
                            // title: Text('Right'),
                            value: 'C',
                            groupValue: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                          Text('Citizen / अन्य'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            // title: Text('Right'),
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

                  if (_selectedCategory == 'S') ...[
                    CustomDropDownButton(
                      // key: UniqueKey(),
                      label: 'कक्षा का चयन करेंं',
                      initialSelection: className,
                      items: provider.groupList
                          .map(
                            (e) => e.subjectName,
                          )
                          .toList(),
                      onSelect: (value) {
                        print(value);

                        var data = provider.groupList
                            .where((element) =>
                                element.subjectName.contains(value))
                            .map((e) => e)
                            .toList();
                        print(data.first.course);
                        print(data.first.subjectId);
                        print(data.first.subjectName);
                        print(data.first.courseName);
                        classCode = data.first.course;
                        className = data.first.subjectName;
                        subjectID = data.first.subjectId;
                        user.courseName = data.first.courseName;
                        setState(() {});
                      },
                    ),
                    AppTheme.verticalSpacing(),
                    Text(
                      user.courseName,
                      textAlign: TextAlign.end,
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: Colors.redAccent),
                    ),
                    AppTheme.verticalSpacing(),
                    // City
                    CustomTextFormField(
                      // key: UniqueKey(),
                      hintText: 'School / College / Institute Name *',
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Enter School / College / Institute Name';
                        }
                      },
                      value: user.collegeName,
                      onChanged: (val) {
                        user.collegeName = val;
                        setState(() {});
                      },
                    ),
                  ],
                  // Gender

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
                    initialSelection: stateName,
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
                      stateName = data.first.stateName;
                      stateCode = data.first.stateId;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  // City
                  CustomTextFormField(
                    // key: UniqueKey(),
                    hintText: 'City / ज़िला *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter city';
                      }
                    },
                    value: user.city,
                    onChanged: (val) {
                      user.city = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),

                  // Complete Address
                  CustomTextFormField(
                    // key: UniqueKey(),
                    hintText: 'Complete Address / पूरा पता *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter address';
                      }
                    },
                    value: user.address,
                    onChanged: (val) {
                      user.address = val;
                      setState(() {});
                    },

                    // : 3,
                  ),
                  AppTheme.verticalSpacing(),

                  // Pincode
                  CustomTextFormField(
                    // key: UniqueKey(),
                    hintText: 'Pincode / पिन कोड *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter pincode';
                      }
                    },
                    value: user.pincode,
                    onChanged: (val) {
                      user.pincode = val;
                      setState(() {});
                    },
                    inputType: TextInputType.number,
                  ),
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
                  // Submit Button
                  AppTheme.verticalSpacing(mul: 2),
                  CustomElevatedBtn(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      var res = await provider.updateProfile(
                        group: classCode,
                        subjectID: subjectID,
                        gender: _selectedGender,
                        schoolName: user.collegeName,
                        name: user.studentName,
                        fName: user.fatherName,
                        dob: DatesUtils.getDateFromString(user.dob),
                        mobile: user.mobile,
                        category: _selectedCategory,
                        state: stateCode,
                        address: user.address,
                        pinCode: user.pincode,
                        language: _selectedLanguage,
                        city: user.city,
                      );

                      ErrorUtils.showSimpleInfoDialog(context,
                          icon: Icons.info_outline_rounded,
                          color: Colors.green,
                          content: Text(res));
                    },
                    text: 'अपडेट प्रोफ़ाइल',
                  ),
                  AppTheme.verticalSpacing(mul: 5),
                ],
              ),
            ),
          ),
        ));
  }
}
