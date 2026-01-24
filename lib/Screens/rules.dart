import 'package:flutter/material.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/routing/app_routing.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ActivityRulesScreen extends StatefulWidget {
  const ActivityRulesScreen({Key? key}) : super(key: key);

  @override
  State<ActivityRulesScreen> createState() => _ActivityRulesScreenState();
}

class _ActivityRulesScreenState extends State<ActivityRulesScreen> {
  List<dynamic> _rulesData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  Future<void> _fetchRules() async {
    const String apiUrl =
        'http://rajsadaksuraksha.versatileitsolution.com/webservice/webservice.asmx/BVP_SelectRuleMaster';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final jsonResponse = json.decode(utf8Body);

        if (jsonResponse['Status'] == 'True' && jsonResponse['Data'] != null) {
          setState(() {
            _rulesData = jsonResponse['Data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = jsonResponse['Message'] ?? 'Failed to fetch data.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to get data from server: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred during API call: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(250), // Increased height for extra images
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.roadbanner),
                fit: BoxFit.cover,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Text(
                            'राष्ट्रीय सड़क सुरक्षा माह, 2026 (1 जनवरी - 31 जनवरी 2026)\n'
                            'राज्य सड़क सुरक्षा प्रकोष्ठ, परिवहन एवं सड़क सुरक्षा विभाग, राजस्थान सरकार द्वारा\n'
                            'जिला सड़क सुरक्षा समिति एवं शिक्षा विभाग के संयुक्त तत्वाधान में आयोजित\n'
                            'ऑनलाईन सड़क सुरक्षा प्रश्नोतरी प्रतियोगिता',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF0E37F6),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              height: 1.4, // ✅ better line spacing
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Text(
                            'आवास युथ सड़क सुरक्षा शिक्षा एवं जागरूकता अभियान',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFC1100),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              'Road Safety Quiz Contest Rules',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _rulesData.length,
                          itemBuilder: (context, index) {
                            final ruleText =
                                _rulesData[index]['RuleText'] ?? '';
                            final isHighlighted =
                                ruleText.contains('50 मिनट') ||
                                    ruleText.contains('सबमिट करते ही');
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: const [
                                        Icon(Icons.circle,
                                            size: 15,
                                            color: Colors
                                                .orangeAccent), // Outer circle
                                        Icon(Icons.circle,
                                            size: 8,
                                            color: Colors
                                                .blueGrey), // Inner circle (smaller, darker)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      color: isHighlighted
                                          ? Colors.grey.shade200
                                          : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Text(
                                        ruleText,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 20.0, top: 10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.pushNamed(AppPages.home);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade800,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'PROCEED',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
