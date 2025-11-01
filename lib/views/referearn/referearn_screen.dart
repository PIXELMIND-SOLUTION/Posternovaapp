
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/referearn/bank_details.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  String referralCode = 'Loading...';
  bool isLoading = true;
  bool isWalletLoading = true;
  String? userId;
  double walletAmount = 0.0;
  double totalEarning = 0.0;

  static const Color primaryColor = Color(0xFF6842FF);
  static const Color lightBlueColor = Color(0xFFE0F7FA);

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  static const TextStyle contentTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    if (mounted) {
      if (userData != null && userData.user != null) {
        setState(() {
          userId = userData.user.id;
        });

        if (userId != null) {
          await Future.wait([
            fetchReferralCode(),
            fetchWalletAmount(),
          ]);
        } else {
          setState(() {
            referralCode = 'User not found';
            isLoading = false;
            isWalletLoading = false;
          });
        }
      } else {
        setState(() {
          referralCode = 'User not found';
          isLoading = false;
          isWalletLoading = false;
        });
      }
    }
  }

  Future<void> fetchWalletAmount() async {
    if (userId == null) return;
    try {
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/users/get-profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          walletAmount = (data['wallet'] ?? 0).toDouble();
          totalEarning = walletAmount; // adjust if business logic differs
          isWalletLoading = false;
        });
      } else {
        setState(() {
          walletAmount = 0.0;
          totalEarning = 0.0;
          isWalletLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        walletAmount = 0.0;
        totalEarning = 0.0;
        isWalletLoading = false;
      });
    }
  }

  Future<void> fetchReferralCode() async {
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/users/refferalcode/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          referralCode = data['referralCode'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        setState(() {
          referralCode = 'Error loading code';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        referralCode = 'Network error';
        isLoading = false;
      });
    }
  }

  Future<void> refreshWalletData() async {
    setState(() {
      isWalletLoading = true;
    });
    await fetchWalletAmount();
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  void copyReferralCode() {
    if (referralCode != 'Loading...' &&
        referralCode != 'Error loading code' &&
        referralCode != 'Network error') {
      Clipboard.setData(ClipboardData(text: referralCode));
      showSnackBar(context, 'Referral code copied!');
    }
  }

  Future<void> shareReferralCode() async {
    if (referralCode != 'Loading...' &&
        referralCode != 'Error loading code' &&
        referralCode != 'Network error') {
      try {
        final String shareMessage = '''
🎉 Join me on our amazing app and get instant rewards! 🎉

Use my referral code: $referralCode

✨ What you get:
• 30 Credits instantly when you sign up
• 50 More credits when you make your first purchase
• Amazing deals and offers

Download the app now and start earning!

#ReferAndEarn #InstantRewards
        ''';

        await Share.share(
          shareMessage,
          subject: 'Join me and earn instant rewards!',
        );

        showSnackBar(context, 'Shared successfully!');
      } catch (e) {
        showSnackBar(context, 'Error sharing referral code');
      }
    }
  }

  void showShareOptions() {
    if (referralCode == 'Loading...' ||
        referralCode == 'Error loading code' ||
        referralCode == 'Network error') {
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Share your referral code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareChip(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () async {
                        Navigator.pop(context);
                        await shareReferralCode();
                      },
                    ),
                    _ShareChip(
                      icon: Icons.content_copy,
                      label: 'Copy',
                      onTap: () {
                        Navigator.pop(context);
                        copyReferralCode();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ——————————————— UI ———————————————

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Refer & Earn', style: titleTextStyle),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([fetchReferralCode(), refreshWalletData()]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _HeaderCard(
              onRedeemTap: walletAmount > 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BankDetailsScreen(),
                        ),
                      );
                    }
                  : null,
              isWalletLoading: isWalletLoading,
              totalEarning: totalEarning,
              walletAmount: walletAmount,
            ),
            const SizedBox(height: 16),
            _ReferralCard(
              isLoading: isLoading,
              referralCode: referralCode,
              onCopy: copyReferralCode,
              onShare: showShareOptions,
            ),
            const SizedBox(height: 16),
            _InfoCard(),
            const SizedBox(height: 16),
            _HowItWorks(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : copyReferralCode,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : showShareOptions,
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const AppText('share_invite_code', style: buttonTextStyle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ——————————————— Pieces ———————————————

class _HeaderCard extends StatelessWidget {
  final VoidCallback? onRedeemTap;
  final bool isWalletLoading;
  final double totalEarning;
  final double walletAmount;

  const _HeaderCard({
    required this.onRedeemTap,
    required this.isWalletLoading,
    required this.totalEarning,
    required this.walletAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [
        Colors.deepPurple,
        Colors.deepPurple.withValues(alpha: 0.5),
      ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6E62FF).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'earn_now',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                _StatTile(
                  labelKey: 'total_earning',
                  value: isWalletLoading ? null : '₹${totalEarning.toStringAsFixed(0)}',
                ),
                const SizedBox(width: 12),
                _StatTile(
                  labelKey: 'current_balance',
                  value: isWalletLoading ? null : '₹${walletAmount.toStringAsFixed(0)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRedeemTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6E62FF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Redeem Now',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String labelKey;
  final String? value;

  const _StatTile({required this.labelKey, required this.value});

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      height: 26,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            value == null
                ? skeleton
                : Text(
                    value!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
            const SizedBox(height: 4),
            AppText(
              labelKey,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferralCard extends StatelessWidget {
  final bool isLoading;
  final String referralCode;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const _ReferralCard({
    required this.isLoading,
    required this.referralCode,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isLoading ||
        referralCode == 'Error loading code' ||
        referralCode == 'Network error';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppText(
              'refer_earn_big',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6842FF),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E1FF)),
              ),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard, color: Colors.deepPurple.shade400),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isLoading ? 'Loading...' : referralCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: disabled ? null : onCopy,
                    icon: const Icon(Icons.copy),
                  ),
                  ElevatedButton(
                    onPressed: disabled ? null : onShare,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const AppText(
              'referral_info',
              style: _ReferEarnScreenState.contentTextStyle,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _surface(),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'introduce_friend',
            style: _ReferEarnScreenState.contentTextStyle,
          ),
          SizedBox(height: 8),
          AppText(
            'bonus_credit',
            style: _ReferEarnScreenState.contentTextStyle,
          ),
        ],
      ),
    );
  }

  BoxDecoration _surface() => BoxDecoration(
        color: const Color(0xFFFDFEFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      );
}

class _HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      _HowItWorksItem(
        icon: Icons.person_add_alt_1,
        title: 'Invite a friend',
        subtitle: 'Share your code using the Share button.',
      ),
      _HowItWorksItem(
        icon: Icons.edit_note,
        title: 'Friend signs up',
        subtitle: 'They enter your code during signup or in settings.',
      ),
      _HowItWorksItem(
        icon: Icons.volunteer_activism,
        title: 'Both get rewards',
        subtitle: 'Credits are added after successful first purchase.',
      ),
    ];

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How it works',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...steps.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: s,
                )),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HowItWorksItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF6842FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6842FF)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShareChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF6842FF).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6842FF), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
