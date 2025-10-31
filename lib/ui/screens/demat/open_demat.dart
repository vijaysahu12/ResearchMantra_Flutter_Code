import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/shimmer_button.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

// 📌 Model for FAQ
class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromMap(Map<String, dynamic> map) {
    return Faq(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }
}

class OpenDematAccountScreen extends StatefulWidget {
  const OpenDematAccountScreen({super.key});

  @override
  State<OpenDematAccountScreen> createState() => _OpenDematAccountScreenState();
}

class _OpenDematAccountScreenState extends State<OpenDematAccountScreen> {
  // 📌 Brokers List
  final List<String> brokers = [
    "Alice Blue",
    "Dhan",
    "Kite",
    "Delta Exchanges",
  ];

  // 📌 FAQ Data (simulate JSON from API/local file)
  final List<Map<String, dynamic>> faqJson = [
    {
      "question": "What is a Demat Account?",
      "answer":
          "A Demat Account holds your shares and securities in electronic form."
    },
    {
      "question": "How long does it take to open?",
      "answer":
          "It usually takes 24-48 hours to get your Demat account activated."
    },
    {
      "question": "Are there any hidden charges?",
      "answer": "No, there are no hidden charges at all."
    },
    {
      "question": "Can I open multiple Demat Accounts?",
      "answer":
          "Yes, you can open multiple Demat accounts with different brokers."
    },
    {
      "question": "Is Aadhar mandatory?",
      "answer":
          "Yes, Aadhar and PAN card are mandatory to open a Demat account."
    },
    {
      "question": "Do I need to maintain a minimum balance?",
      "answer": "No, there is no minimum balance requirement in Demat accounts."
    },
  ];

  late final List<Faq> faqs;

  @override
  void initState() {
    super.initState();
    // Convert JSON → Model
    faqs = faqJson.map((item) => Faq.fromMap(item)).toList();
  }

  // 📌 Show Broker BottomSheet
  void _showBrokerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Your Broker",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: brokers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final broker = brokers[index];
                  return ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(broker),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 📌 Build FAQ List
// 📌 FAQ Section
  Widget _buildFaqSection() {
    return SizedBox(
      height: 350.h,
      child: ListView.separated(
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            iconColor: Colors.black,
            collapsedIconColor: Colors.black54,
            title: Text(
              faq.question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.answer,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 📌 Build Main UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Demat Account",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Section with Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.shadowColor),
                  color: theme.cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📌 Heading
                    Text(
                      "Open Now Free Demat Account\nNo Hidden Charges",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 📌 Bullet Points
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint("Smart Trades with Us", theme),
                        _buildBulletPoint("Zero Data Leakage", theme),
                        _buildBulletPoint("Optimised Market View", theme),
                        _buildBulletPoint("Smart Watchlist", theme),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 📌 Open Now Button
                    _buildButton(theme)
                  ],
                ),
              ),

              SizedBox(height: 12.h),
              _buildOpenDemat(),
              SizedBox(height: 12.h),
              // FAQ Header
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "FAQs",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // FAQ Section
              _buildFaqSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 18, right: 18, top: 5),
        child: _buildButton(theme),
      ),
    );
  }

  //Widget for Open demat button
  Widget _buildButton(theme) {
    return ShimmerButton(
      borderRadius: 4,
      text: "Open Demat Account",
      backgroundColor: theme.primaryColorDark,
      textColor: theme.primaryColor,
      onPressed: () {
        _showBrokerBottomSheet();
      },
    );
  }

  ///Widget For Demat Account Opening Video
  Widget _buildOpenDemat() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //TODO: Navigate To Youtube or Need to show Video in Here in separate full screen
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
                imageUrl:
                    "https://static.hdfcsky.com/wp-content/uploads/2025/06/How-to-Open-a-Demat-Account_.webp"),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
