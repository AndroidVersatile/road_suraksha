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
  String? selectedBlockName; // ✅ ADD THIS
  String? selectedDistrictName; // ✅ ADD THIS
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
  String? stateError;
  String? districtError;
  String? blockError;
  @override
  void initState() {
    super.initState();
    _selectedCategory = 'S';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<LoginProvider>();

      await provider.getStateList();
      await provider.getClassList();

      // ✅ IMPORTANT: Rajasthan ke districts load karo on init
      if (provider.stateList.isNotEmpty) {
        provider.selectedStateId = '29'; // Rajasthan
        await provider.getDistrictList('29');
      }
    });
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
                  ],
                ),
                AppTheme.verticalSpacing(),

                // Category
                Text('Category / वर्ग *', style: context.textTheme.labelLarge),
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

                // ✅ Class Selection (Only if Student)
                if (_selectedCategory == 'S') ...[
                  CustomDropDownButton(
                    label: 'कक्षा का चयन करें',
                    items:
                        provider.groupList.map((e) => e.subjectName).toList(),
                    initialSelection: '',
                    onSelect: (value) {
                      setState(() {
                        selectedClass = value;
                        classError = null;
                      });

                      try {
                        var data = provider.groupList.firstWhere(
                            (element) => element.subjectName == value);

                        classes = data.course;
                        subjectID = data.subjectId;
                        level = data.courseName;
                      } catch (e) {
                        print("❌ Class selection error: $e");
                      }
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
                    style: context.textTheme.titleSmall
                        ?.copyWith(color: Colors.redAccent),
                  ),
                  AppTheme.verticalSpacing(),

                  // School Name
                  CustomTextFormField(
                    hintText: 'School / College / Institute Name *',
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Enter School / College / Institute Name';
                      }
                    },
                    value: schoolName,
                    onChanged: (val) {
                      schoolName = val;
                      setState(() {});
                    },
                  ),
                  AppTheme.verticalSpacing(),
                ],

                // Gender
                Text('Gender / लिंग *', style: context.textTheme.labelLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio(
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

                // ✅ STATE DROPDOWN (Fixed - Rajasthan only, Read-only look)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'राज्य / State *',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'राजस्थान',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Icon(
                          //   Icons.lock_outline,
                          //   size: 18,
                          //   color: Colors.grey[600],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppTheme.verticalSpacing(),

                // ✅ DISTRICT DROPDOWN
            // ✅ DISTRICT DROPDOWN - Update onSelect
CustomDropDownButton(
  label: 'ज़िला चुनें *',
  items: provider.districtList.map((e) => e.districtName).toList(),
  initialSelection: '',
  onSelect: (value) {
    setState(() {
      districtError = null;
    });

    print("🟢 District selected: $value");

    try {
      final district = provider.districtList
          .firstWhere((e) => e.districtName == value);

      provider.selectedDistrictId = district.districtId;
      provider.selectedDistrictName = district.districtName; // ✅ ADD THIS LINE
      provider.selectedBlockId = ''; // ✅ Reset block
      provider.getBlockList(district.districtId);

      setState(() {});
    } catch (e) {
      print("❌ District selection error: $e");
    }
  },
),
                AppTheme.verticalSpacing(),

                // ✅ BLOCK DROPDOWN
                // CustomDropDownButton(
                //   label: 'ब्लॉक चुनें *',
                //   items: provider.blockList.map((e) => e.blockName).toList(),
                //   initialSelection: '',
                //   onSelect: (value) {
                //     setState(() {
                //       blockError = null;
                //     });

                //     try {
                //       final block = provider.blockList
                //           .firstWhere((e) => e.blockName == value);

                //       provider.selectedBlockId = block.blockId;

                //       setState(() {});
                //     } catch (e) {
                //       print("❌ Block selection error: $e");
                //     }
                //   },
                // ),
                // if (blockError != null)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                //     child: Text(
                //       blockError!,
                //       style: const TextStyle(color: Colors.red, fontSize: 12),
                //     ),
                //   ),
                // ✅ BLOCK DROPDOWN - Proper implementation
if (provider.selectedDistrictId.isEmpty)
  // Show disabled state
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(AppTheme.radius),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'पहले ज़िला चुनें',
          style: TextStyle(color: Colors.grey[600]),
        ),
        Icon(Icons.lock_outline, color: Colors.grey[400], size: 18),
      ],
    ),
  )
else if (provider.loading)
  // Show loading
  const Center(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    ),
  )
else
  // Show dropdown
   CustomDropDownButton(
    label: 'ब्लॉक चुनें *',
    items: provider.blockList.map((e) => e.blockName).toList(),
    initialSelection: '',
    onSelect: (value) {
      setState(() {
        blockError = null;
      });

      try {
        final block = provider.blockList
            .firstWhere((e) => e.blockName == value);

        provider.selectedBlockId = block.blockId;
        selectedBlockName = block.blockName; // ✅ ADD THIS
        
        setState(() {});
      } catch (e) {
        print("❌ Block selection error: $e");
      }
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
                AppTheme.verticalSpacing(mul: 3),

                // ✅ SUBMIT BUTTON
                CustomElevatedBtn(
                  onPressed: () async {
                    // Validate class selection if category is Student
                    if (_selectedCategory == 'S' &&
                        (selectedClass == null || selectedClass!.isEmpty)) {
                      setState(() {
                        classError = 'कृपया कक्षा का चयन करें';
                      });
                      return;
                    }

                    // ✅ Validate District selection
                    if (provider.selectedDistrictId.isEmpty) {
                      setState(() {
                        districtError = 'कृपया ज़िला का चयन करें';
                      });
                      return;
                    }

                    // ✅ Validate Block selection
                    if (provider.selectedBlockId.isEmpty) {
                      setState(() {
                        blockError = 'कृपया ब्लॉक का चयन करें';
                      });
                      return;
                    }

                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    // ✅ Loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      print("📤 Sending registration request...");
                      print("Group: $classes");
                      print("SubjectID: $subjectID");
                      print("StateID: 29"); // ✅ Fixed Rajasthan
                      print("DistrictID: ${provider.selectedDistrictId}");
                      print("BlockID: ${provider.selectedBlockId}");

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
                        state: '29', // ✅ Rajasthan State ID
                        districtId:
                            provider.selectedDistrictId, // ✅ MUST NOT be empty
                        blockId:
                            provider.selectedBlockId,
                              blockName: selectedBlockName ?? '', // ✅ ADD THIS
  districtName: provider.selectedDistrictName, // ✅ ADD THIS LINE

                        address: address,
                        pinCode: pinCode,
                        language: _selectedLanguage,
                        utrNo: "123456",
                        city: city,
                      );

                      print("📥 After Registration:");
                      print("StateID: ${provider.selectedStateId}");
                      print("DistrictID: ${provider.selectedDistrictId}");
                      print("BlockID: ${provider.selectedBlockId}");
                      // ✅ Close loading
                      Navigator.of(context).pop();

                      print("📥 Register Response: $res");

                      if (res != null) {
                        final status = res['Status']?.toString().toLowerCase();

                        if (status == 'true') {
                          ErrorUtils.showSimpleInfoDialog(
                            context,
                            icon: Icons.check_circle_outline,
                            color: Colors.green,
                            content: Text(
                                '${res['Message'] ?? 'Registration Successful'}'),
                            onConfirm: () {
                              Navigator.of(context).pop(); // dialog
                              Navigator.of(context).pop(); // register screen
                            },
                          );
                        } else {
                          ErrorUtils.showSimpleInfoDialog(
                            context,
                            icon: Icons.error_outline,
                            color: Colors.red,
                            content: Text(
                                '${res['Message'] ?? 'Registration Failed'}'),
                            onConfirm: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      } else {
                        ErrorUtils.showSimpleInfoDialog(
                          context,
                          icon: Icons.error_outline,
                          color: Colors.red,
                          content: const Text('Server Error'),
                          onConfirm: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    } catch (e, stackTrace) {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }

                      print("❌ Register Error: $e");
                      print("❌ Stack: $stackTrace");

                      ErrorUtils.showErrorSnackBar(
                          "Something went wrong: ${e.toString()}");
                    }
                  },
                  text: 'Submit',
                ),
                AppTheme.verticalSpacing(mul: 4),
              ],
            ),
          ),
        ),
      ),
    );
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
