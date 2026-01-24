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

  String? stateError;
  String? districtError;
  String? blockError;
  
@override
void initState() {
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      final loginProvider = context.read<LoginProvider>();

      // ✅ First load from cache
      String cachedDistrictId = await loginProvider.cache.getDistrictId();
      String cachedBlockId = await loginProvider.cache.getBlockId();

      if (cachedDistrictId.isNotEmpty && cachedDistrictId != '0') {
        loginProvider.selectedDistrictId = cachedDistrictId;
        print("📦 Loaded DistrictId from cache: $cachedDistrictId");
      }

      if (cachedBlockId.isNotEmpty && cachedBlockId != '0') {
        loginProvider.selectedBlockId = cachedBlockId;
        print("📦 Loaded BlockId from cache: $cachedBlockId");
      }

      // ✅ Fetch user details and lists
      await loginProvider.getUserDetails();
      await loginProvider.getStateList();
      await loginProvider.getClassList();

      final user = loginProvider.userModel;

      if (user != null) {
        // ✅ Set State
        stateCode = user.state;
        var stateData = loginProvider.stateList
            .where((element) => element.stateId.contains(stateCode))
            .toList();

        if (stateData.isNotEmpty) {
          stateName = stateData.first.stateName;
          print("📍 State: $stateName");
        }

        // ✅ Load Districts
        if (stateCode.isNotEmpty) {
          loginProvider.selectedStateId = stateCode;
          await loginProvider.getDistrictList(stateCode);

          // ✅ Use provider's saved IDs (already loaded from cache or registration)
          if (loginProvider.selectedDistrictId.isNotEmpty && 
              loginProvider.selectedDistrictId != '0') {
            
            print("📍 Using DistrictId: ${loginProvider.selectedDistrictId}");

            // ✅ Load Blocks
            await loginProvider.getBlockList(loginProvider.selectedDistrictId);

            if (loginProvider.selectedBlockId.isNotEmpty && 
                loginProvider.selectedBlockId != '0') {
              
              print("📍 Using BlockId: ${loginProvider.selectedBlockId}");
            }
          }
        }

        // ✅ Set Class
        classCode = user.course;
        var subName = loginProvider.groupList
            .where((element) => element.course.contains(classCode))
            .toList();

        if (subName.isNotEmpty) {
          className = subName.first.subjectName;
          subjectID = subName.first.subjectId;
        }

        // ✅ Set selected values
        _selectedLanguage = user.language;
        _selectedCategory = user.category;
        _selectedGender = user.citizen;

        setState(() {});
      }
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
      // ✅ State - Read Only (Cannot Change)
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'राज्य / State',
      style: context.textTheme.labelMedium?.copyWith(
        color: Colors.grey[700],
      ),
    ),
    const SizedBox(height: 8),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[200], // ✅ Disabled look
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        stateName.isNotEmpty ? stateName : 'राजस्थान', // ✅ Fixed state
        style: context.textTheme.bodyLarge?.copyWith(
          color: Colors.grey[800],
        ),
      ),
    ),
  ],
),

AppTheme.verticalSpacing(),
                  AppTheme.verticalSpacing(),

                  CustomDropDownButton(
                    label: 'ज़िला चुनें',
                    items: provider.districtList
                        .map((e) => e.districtName)
                        .toList(),

                    // ✅ Initial selection (agar user profile mein saved ho)
                    initialSelection: provider.selectedDistrictId.isNotEmpty
                        ? (provider.districtList
                                .where((e) =>
                                    e.districtId == provider.selectedDistrictId)
                                .map((e) => e.districtName)
                                .firstOrNull ??
                            '')
                        : '',

                    // ✅ Dynamic update
                    selectedValue: provider.selectedDistrictId.isEmpty
                        ? null
                        : provider.districtList
                            .where((e) =>
                                e.districtId == provider.selectedDistrictId)
                            .map((e) => e.districtName)
                            .firstOrNull,

                    onSelect: (value) async {
                      setState(() {
                        districtError = null;
                      });

                      try {
                        final district = provider.districtList
                            .firstWhere((e) => e.districtName == value);

                        provider.selectedDistrictId = district.districtId;
                        provider.selectedBlockId = '';

                        await provider.getBlockList(district.districtId);

                        setState(() {}); // ✅ UI update
                      } catch (e) {
                        print("❌ District selection error: $e");
                      }
                    },
                  ),
                  AppTheme.verticalSpacing(),
                  CustomDropDownButton(
                    label: 'ब्लॉक चुनें',
                    items: provider.blockList.map((e) => e.blockName).toList(),

                    // ✅ Initial selection
                    initialSelection: provider.selectedBlockId.isNotEmpty
                        ? (provider.blockList
                                .where((e) =>
                                    e.blockId == provider.selectedBlockId)
                                .map((e) => e.blockName)
                                .firstOrNull ??
                            '')
                        : '',

                    // ✅ Dynamic update
                    selectedValue: provider.selectedBlockId.isEmpty
                        ? null
                        : provider.blockList
                            .where((e) => e.blockId == provider.selectedBlockId)
                            .map((e) => e.blockName)
                            .firstOrNull,

                    onSelect: (value) {
                      setState(() {
                        blockError = null;
                      });

                      try {
                        final block = provider.blockList
                            .firstWhere((e) => e.blockName == value);

                        provider.selectedBlockId = block.blockId;

                        setState(() {}); // ✅ UI update
                      } catch (e) {
                        print("❌ Block selection error: $e");
                      }
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
                      // Validate State selection
                      if (provider.selectedStateId.isEmpty) {
                        setState(() {
                          stateError = 'कृपया राज्य का चयन करें';
                        });
                        return;
                      }

                      // Validate District selection
                      if (provider.selectedDistrictId.isEmpty) {
                        setState(() {
                          districtError = 'कृपया ज़िला का चयन करें';
                        });
                        return;
                      }

                      // Validate Block selection
                      if (provider.selectedBlockId.isEmpty) {
                        setState(() {
                          blockError = 'कृपया ब्लॉक का चयन करें';
                        });
                        return;
                      }

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
                        state: provider.selectedStateId,
                        address: user.address,
                        pinCode: user.pincode,
                        language: _selectedLanguage,
                        city: user.city,
                        districtId: provider.selectedDistrictId, // ✅ Add karo
                        blockId: provider.selectedBlockId,
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
