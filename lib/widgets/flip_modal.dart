import 'package:flutter/material.dart';
import 'package:posternova/widgets/language_widget.dart';

class _FlippableReferModal extends StatefulWidget {
  final bool isLoading;
  final String? errorMessage;
  final String? userReferralCode;
  final VoidCallback onLoadReferralCode;
  final VoidCallback onShare;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  const _FlippableReferModal({
    required this.isLoading,
    required this.errorMessage,
    required this.userReferralCode,
    required this.onLoadReferralCode,
    required this.onShare,
    required this.onClose,
    required this.onCopy,
  });

  @override
  State<_FlippableReferModal> createState() => _FlippableReferModalState();
}

class _FlippableReferModalState extends State<_FlippableReferModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _flipAnimation.addListener(() {
      // Switch content halfway through flip
      if (_flipAnimation.value >= 0.5 && !_showBack) {
        setState(() => _showBack = true);
      } else if (_flipAnimation.value < 0.5 && _showBack) {
        setState(() => _showBack = false);
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.people_outline, color: Color(0xFF4F46E5), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AppText(
                          'refer_earn',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                        ),
                      ),
                      // Flip hint button
                      GestureDetector(
                        onTap: _flip,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _flipAnimation,
                                builder: (_, __) => Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(_flipAnimation.value * 3.14159),
                                  child: const Icon(Icons.flip_camera_android_rounded,
                                      color: Color(0xFF4F46E5), size: 16),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _showBack ? 'My Code' : 'How it works',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, size: 24),
                        color: Colors.grey[600],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // ── Flipping Card ────────────────────────────────────────
                GestureDetector(
                  onTap: _flip,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, _) {
                      final angle = _flipAnimation.value * 3.14159;
                      // Flip Y axis — first half shows front, second half shows back (mirrored)
                      final isSecondHalf = _flipAnimation.value >= 0.5;
                      final displayAngle = isSecondHalf ? angle - 3.14159 : angle;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspective
                          ..rotateY(angle),
                        child: Transform(
                          alignment: Alignment.center,
                          // Mirror the back face so text isn't reversed
                          transform: isSecondHalf
                              ? (Matrix4.identity()..rotateY(3.14159))
                              : Matrix4.identity(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: _showBack
                                ? _buildHowItWorksContent()
                                : _buildMyCodeContent(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Flip hint text ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_rounded, size: 13, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        'Tap card to flip',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),

                // ── Common Buttons (always visible) ──────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onCopy,
                          icon: const Icon(Icons.copy, size: 20),
                          label: const Text('Copy Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.userReferralCode != null ? widget.onShare : null,
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyCodeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info_outline, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: AppText(
                  'share_referral_earn',
                  style: TextStyle(fontSize: 13, color: Color(0xFF0C4A6E), height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const AppText(
          'your_referral_code',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 10),
        if (widget.isLoading)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4F46E5))),
                SizedBox(width: 12),
                Text('Loading...', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              ],
            ),
          )
        else if (widget.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(widget.errorMessage!, style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)))),
                TextButton(onPressed: widget.onLoadReferralCode, child: const Text('Retry')),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userReferralCode ?? '--',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                      const Text('Your unique referral code',
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.card_giftcard_rounded,
                      color: Color(0xFF4F46E5), size: 28),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHowItWorksContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'how_it_works',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        ),
        const SizedBox(height: 16),
        _howItWorksStep('1', Icons.share_rounded, 'share_your_code',
            'send_referral_any_platform', const Color(0xFF6366F1)),
        const SizedBox(height: 12),
        _howItWorksStep('2', Icons.person_add_rounded, 'friend_signs_up',
            'enter_code_during_signup', const Color(0xFF0EA5E9)),
        const SizedBox(height: 12),
        _howItWorksStep('3', Icons.emoji_events_rounded, 'earn_rewards',
            'get_200_on_upgrade', const Color(0xFF10B981)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _howItWorksStep(
      String number, IconData icon, String titleKey, String descKey, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: color, size: 20),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(titleKey,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 3),
              AppText(descKey,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}