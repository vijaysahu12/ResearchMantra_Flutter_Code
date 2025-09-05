import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/screens/multibaggers/multibaggers.dart';

class XclusiveScreen extends StatefulWidget {
  const XclusiveScreen({super.key});

  @override
  State<XclusiveScreen> createState() => _XclusiveScreenState();
}

class _XclusiveScreenState extends State<XclusiveScreen> {
  final List<Map<String, dynamic>> picksData = [
    {
      "id": 44,
      "title": "Top New Year Picks",
      "imageUrl":
          "https://w3assets.angelone.in/wp-content/uploads/2024/10/Diwali-2024-Stock-Picks-Shagun-Ke-Shares-for-Samvat-2081-768x388.jpg",
    },
    {
      "id": 45,
      "title": "High Growth Multibaggers",
      "imageUrl":
          "https://img.etimg.com/thumb/msid-117883280,width-640,resizemode-4/markets/stocks/news/markets-after-budget-from-ril-to-kpit-here-are-top-stock-picks-from-brokerages/budget-plays.jpg",
    },
    {
      "id": 46,
      "title": "Safe Long-Term Bets",
      "imageUrl":
          "https://plus.unsplash.com/premium_photo-1663840297088-5b76140d74ba?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aGFwcHklMjBuZXclMjB5ZWFyfGVufDB8fDB8fHww",
    },
    {
      "id": 526,
      "title": "Post Budget",
      "imageUrl":
          "https://images.moneycontrol.com/static-mcnews/2024/02/Budget-CM-Development-1.jpg?impolicy=website&width=1600&height=900",
    },
    {
      "id": 412,
      "title": "After budget Budget",
      "imageUrl":
          "https://w3assets.angelone.in/wp-content/uploads/2024/02/Stocks-to-watch-today-19-feb-2024-768x386.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Xclusive Pro",
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: ListView.builder(
        itemCount: picksData.length,
        itemBuilder: (context, index) {
          return AspectRatio(
              aspectRatio: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultibaggersScreen(),
                      ),
                    );
                  },
                  child: CircularCachedNetworkLandScapeImages(
                    imageURL: picksData[index]['imageUrl'],
                    baseUrl: "nobase",
                    defaultImagePath: "",
                    aspectRatio: 2,
                  ),
                ),
              ));
        },
      ),
    );
  }
}
