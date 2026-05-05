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
  
  // Language, Category, Gender
  String _selectedLanguage = 'H';
  String _selectedCategory = 'S';
  String _selectedGender = 'M';
  
  // Form Fields
  String name = '';
  String fName = '';
  DateTime dob = DateTime.now();
  String mobile = '';
  String schoolName = '';
  String address = '';
  String pinCode = '';
  String city = '';
  
  // Class Related
  String classes = '';
  String subjectID = '';
  String level = '';
  String? selectedClass;
  
  // Location Related
  String? selectedDistrictName;
  String? selectedBlockName;
  
  // Validation Errors
  String? classError;
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

      // Load Rajasthan districts on init
      if (provider.stateList.isNotEmpty) {
        provider.selectedStateId = '29'; // Rajasthan State ID
        await provider.getDistrictList('29');
      }
    });
  }

  // Validate all selections before submission
  bool _validateSelections(LoginProvider provider) {
    bool isValid = true;

    // Validate Class if Student category
    if (_selectedCategory == 'S' && 
        (selectedClass == null || selectedClass!.isEmpty)) {
      setState(() {
        classError = 'कृपया कक्षा का चयन करें / Please select class';
      });
      isValid = false;
    }

    // Validate District
    if (provider.selectedDistrictId.isEmpty || 
        selectedDistrictName == null || 
        selectedDistrictName!.isEmpty) {
      setState(() {
        districtError = 'कृपया ज़िला का चयन करें / Please select district';
      });
      isValid = false;
    }

    // Validate Block
    if (provider.selectedBlockId.isEmpty || 
        selectedBlockName == null || 
        selectedBlockName!.isEmpty) {
      setState(() {
        blockError = 'कृपया ब्लॉक का चयन करें / Please select block';
      });
      isValid = false;
    }

    // Show error message if validation fails
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'कृपया सभी आवश्यक फ़ील्ड भरें / Please fill all required fields',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    return isValid;
  }

  // Handle form submission
  Future<void> _handleSubmit(LoginProvider provider) async {
    // Clear previous errors
    setState(() {
      classError = null;
      districtError = null;
      blockError = null;
    });

    // Validate selections
    if (!_validateSelections(provider)) {
      return;
    }

    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      print("📤 Sending registration request...");
      print("Name: $name");
      print("Father Name: $fName");
      print("Mobile: $mobile");
      print("Category: $_selectedCategory");
      print("Gender: $_selectedGender");
      print("Group: $classes");
      print("SubjectID: $subjectID");
      print("StateID: 29 (Rajasthan)");
      print("DistrictID: ${provider.selectedDistrictId}");
      print("DistrictName: $selectedDistrictName");
      print("BlockID: ${provider.selectedBlockId}");
      print("BlockName: $selectedBlockName");
      print("Address: $address");
      print("Pincode: $pinCode");

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
        state: '29', // Rajasthan State ID
        districtId: provider.selectedDistrictId,
        blockId: provider.selectedBlockId,
        blockName: selectedBlockName ?? '',
        districtName: selectedDistrictName ?? '',
        address: address,
        pinCode: pinCode,
        language: _selectedLanguage,
        utrNo: "123456",
        city: city,
      );

      // Close loading indicator
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      print("📥 Register Response: $res");

      // Handle response
      if (res != null) {
        final status = res['Status']?.toString().toLowerCase();

        if (status == 'true') {
          ErrorUtils.showSimpleInfoDialog(
            context,
            icon: Icons.check_circle_outline,
            color: Colors.green,
            content: Text('${res['Message'] ?? 'Registration Successful'}'),
            onConfirm: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close register screen
            },
          );
        } else {
          ErrorUtils.showSimpleInfoDialog(
            context,
            icon: Icons.error_outline,
            color: Colors.red,
            content: Text('${res['Message'] ?? 'Registration Failed'}'),
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
          content: const Text('Server Error - Please try again'),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e, stackTrace) {
      // Close loading if still open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      print("❌ Register Error: $e");
      print("❌ Stack: $stackTrace");

      ErrorUtils.showErrorSnackBar(
        "Registration failed: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(CommonText.register),
      ),
      body: Container(
        margin: AppTheme.boxPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTheme.verticalSpacing(),

                // Name Field
                CustomTextFormField(
                  hintText: 'Name / नाम *',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'कृपया नाम दर्ज करें / Please enter name';
                    }
                    return null;
                  },
                  value: name,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                AppTheme.verticalSpacing(),

                // Father's Name Field
                CustomTextFormField(
                  hintText: 'Father Name / पिता का नाम *',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'कृपया पिता का नाम दर्ज करें / Please enter father name';
                    }
                    return null;
                  },
                  value: fName,
                  onChanged: (val) {
                    setState(() {
                      fName = val;
                    });
                  },
                ),
                AppTheme.verticalSpacing(),

                // Date of Birth
                PickTimeWidget(
                  title: 'DOB / जन्म तिथि *',
                  initialValue: DateTime.now(),
                  onPickedDate: (val) {
                    setState(() {
                      dob = val;
                    });
                  },
                  isPreviousDate: true,
                  isFutureDate: false,
                ),
                AppTheme.verticalSpacing(),

                // WhatsApp Number
                CustomTextFormField(
                  hintText: 'Whatsapp No. / व्हाट्सएप नं *',
                  length: 10,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'कृपया मोबाइल नंबर दर्ज करें / Please enter mobile number';
                    }
                    if (val.length != 10) {
                      return 'मोबाइल नंबर 10 अंकों का होना चाहिए / Mobile number must be 10 digits';
                    }
                    return null;
                  },
                  value: mobile,
                  onChanged: (val) {
                    setState(() {
                      mobile = val;
                    });
                  },
                  inputType: TextInputType.phone,
                ),
                AppTheme.verticalSpacing(),

                // Exam Language Selection
                Text(
                  'Exam Language / परीक्षा की भाषा *',
                  style: context.textTheme.labelLarge,
                ),
                AppTheme.verticalSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                AppTheme.verticalSpacing(),

                // Category Selection
                Text(
                  'Category / वर्ग *',
                  style: context.textTheme.labelLarge,
                ),
                AppTheme.verticalSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const Text('Student / विद्यार्थी'),
                  ],
                ),
                AppTheme.verticalSpacing(),

                // Class Selection (Only for Students)
                if (_selectedCategory == 'S') ...[
                  CustomDropDownButton(
                    label: 'कक्षा का चयन करें / Select Class *',
                    items: provider.groupList.map((e) => e.subjectName).toList(),
                    initialSelection: '',
                    onSelect: (value) {
                      setState(() {
                        selectedClass = value;
                        classError = null;
                      });

                      try {
                        var data = provider.groupList.firstWhere(
                          (element) => element.subjectName == value,
                        );

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
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  AppTheme.verticalSpacing(),
                  
                  if (level.isNotEmpty)
                    Text(
                      level,
                      textAlign: TextAlign.end,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  AppTheme.verticalSpacing(),

                  // School Name
                  CustomTextFormField(
                    hintText: 'School / College / Institute Name *',
                    validator: (val) {
                      if (_selectedCategory == 'S' && (val == null || val.isEmpty)) {
                        return 'कृपया स्कूल/कॉलेज का नाम दर्ज करें / Please enter school/college name';
                      }
                      return null;
                    },
                    value: schoolName,
                    onChanged: (val) {
                      setState(() {
                        schoolName = val;
                      });
                    },
                  ),
                  AppTheme.verticalSpacing(),
                ],

                // Gender Selection
                Text(
                  'Gender / लिंग *',
                  style: context.textTheme.labelLarge,
                ),
                AppTheme.verticalSpacing(),
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
                        const Text('Male / पुरुष'),
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
                        const Text('Female / महिला'),
                      ],
                    ),
                  ],
                ),
                AppTheme.verticalSpacing(),

                // State (Fixed - Rajasthan)
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
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        'राजस्थान / Rajasthan',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                AppTheme.verticalSpacing(),

                // District Selection
                CustomDropDownButton(
                  label: 'ज़िला चुनें / Select District *',
                  items: provider.districtList.map((e) => e.districtName).toList(),
                  initialSelection: '',
                  onSelect: (value) {
                    setState(() {
                      districtError = null;
                      blockError = null;
                    });

                    print("🟢 District selected: $value");

                    try {
                      final district = provider.districtList.firstWhere(
                        (e) => e.districtName == value,
                      );

                      provider.selectedDistrictId = district.districtId;
                      selectedDistrictName = district.districtName;
                      
                      // Reset block selection when district changes
                      provider.selectedBlockId = '';
                      selectedBlockName = null;
                      
                      // Load blocks for selected district
                      provider.getBlockList(district.districtId);

                      setState(() {});
                    } catch (e) {
                      print("❌ District selection error: $e");
                    }
                  },
                ),
                if (districtError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      districtError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                AppTheme.verticalSpacing(),

                // Block Selection
                if (provider.selectedDistrictId.isEmpty)
                  // Show disabled state
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'पहले ज़िला चुनें / First select district',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Icon(
                          Icons.lock_outline,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ],
                    ),
                  )
                else if (provider.loading)
                  // Show loading indicator
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  // Show block dropdown
                  CustomDropDownButton(
                    label: 'ब्लॉक चुनें / Select Block *',
                    items: provider.blockList.map((e) => e.blockName).toList(),
                    initialSelection: '',
                    onSelect: (value) {
                      setState(() {
                        blockError = null;
                      });

                      print("🟢 Block selected: $value");

                      try {
                        final block = provider.blockList.firstWhere(
                          (e) => e.blockName == value,
                        );

                        provider.selectedBlockId = block.blockId;
                        selectedBlockName = block.blockName;

                        setState(() {});
                      } catch (e) {
                        print("❌ Block selection error: $e");
                      }
                    },
                  ),
                if (blockError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      blockError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                AppTheme.verticalSpacing(),

                // Complete Address
                CustomTextFormField(
                  hintText: 'Complete Address / पूरा पता *',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'कृपया पूरा पता दर्ज करें / Please enter complete address';
                    }
                    return null;
                  },
                  value: address,
                  onChanged: (val) {
                    setState(() {
                      address = val;
                    });
                  },
                ),
                AppTheme.verticalSpacing(),

                // Pincode
                CustomTextFormField(
                  hintText: 'Pincode / पिन कोड *',
                  length: 6,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'कृपया पिन कोड दर्ज करें / Please enter pincode';
                    }
                    if (val.length != 6) {
                      return 'पिन कोड 6 अंकों का होना चाहिए / Pincode must be 6 digits';
                    }
                    return null;
                  },
                  value: pinCode,
                  onChanged: (val) {
                    setState(() {
                      pinCode = val;
                    });
                  },
                  inputType: TextInputType.number,
                ),
                AppTheme.verticalSpacing(mul: 3),

                // Submit Button
                CustomElevatedBtn(
                  onPressed: () => _handleSubmit(provider),
                  text: 'Submit / जमा करें',
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

// QR Screen (unchanged)
class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LoginProvider>().getQRInstruction();
    context.read<LoginProvider>().getQrCode();
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
              AppTheme.verticalSpacing(mul: 3),
              CustomElevatedBtn(
                onPressed: () {
                  context.pushNamed(AppPages.register);
                },
                text: 'Go to register page',
              ),
              AppTheme.verticalSpacing(mul: 3),
            ],
          ),
        ),
      ),
    );
  }
}