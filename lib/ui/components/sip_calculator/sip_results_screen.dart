import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_market_returns.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_summary.dart';

class SipResults extends StatelessWidget {
  final SipResponseModel response;
  final bool incrementalRate;
  const SipResults({
    super.key,
    required this.response,
    required this.incrementalRate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: theme.appBarTheme.backgroundColor,
            appBar: CommonAppBarWithBackButton(
              appBarText: "Results",
              handleBackButton: () {
                Navigator.pop(context);
              },
            ),
            body: Column(
              children: [
                TabBar(
                  indicatorColor: theme.disabledColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: theme.disabledColor,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Summary'),
                    Tab(text: 'Market Returns'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SipSummary(
                        expectedAmount: response.expectedAmount == null
                            ? 0
                            : response.expectedAmount ?? 0,
                        amountInvested: response.amountInvested == null
                            ? 0
                            : response.amountInvested ?? 0,
                        wealthGain: response.wealthGain == null
                            ? 0
                            : response.wealthGain ?? 0,
                      ),
                      SipMarketReturns(
                        expectedAmount: response.expectedAmount == null
                            ? 0
                            : response.expectedAmount ?? 0,
                        amountInvested: response.amountInvested == null
                            ? 0
                            : response.amountInvested ?? 0,
                        wealthGain: response.wealthGain == null
                            ? 0
                            : response.wealthGain ?? 0,
                        incrementalRate: incrementalRate,
                        projectedSipReturnsTable:
                            response.projectedSipReturnsTable == null
                                ? []
                                : response.projectedSipReturnsTable ?? [],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Button(
                text: "Calculate Again",
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: theme.indicatorColor,
                textColor: theme.floatingActionButtonTheme.foregroundColor,
              ),
            ),
          ),
        ));
  }
}
