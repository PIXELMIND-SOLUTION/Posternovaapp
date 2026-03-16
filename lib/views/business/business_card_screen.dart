import 'package:flutter/material.dart';

class BusinessCardScreen extends StatelessWidget {
  const BusinessCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionHeader('Trending Cards', context),
                    const SizedBox(height: 12),
                    _buildTrendingCards(),
                    const SizedBox(height: 20),
                    _buildPromoBanner(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Professional Cards', context),
                    const SizedBox(height: 12),
                    _buildProfessionalCards(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Digital Business Card',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCards() {
    return SizedBox(
      height: 320,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTrendingCard1(),
          const SizedBox(width: 12),
          _buildTrendingCard2(),
          const SizedBox(width: 12),
          _buildTrendingCard3(),
        ],
      ),
    );
  }

  // ── Card 1: gradient bg + network logo image ──────────────────────────────
  Widget _buildTrendingCard1() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6EC6F5), Color(0xFF9B59B6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Subtle bg texture
                  Image.network(
                    'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400&q=80',
                    fit: BoxFit.cover,
                    color: Colors.blue.withOpacity(0.3),
                    colorBlendMode: BlendMode.multiply,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.download, size: 14, color: Colors.blue),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'UPI\nPayment',
                                style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Circular logo with network image
                        Center(
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Text('LOGO',
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text('Your Business Name',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const Center(
                          child: Text('#1 platform for digital business',
                              style: TextStyle(fontSize: 8, color: Colors.white70)),
                        ),
                        const SizedBox(height: 4),
                        Container(height: 0.5, color: Colors.white54),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _miniIconText(Icons.phone, '9518311798'),
                            _miniIconText(Icons.email, 'email@site.com'),
                            _miniIconText(Icons.location_on, '1234, Area'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text('CONNECT WITH US',
                              style: TextStyle(fontSize: 7, color: Colors.white70, letterSpacing: 1)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIcon(Icons.facebook, Colors.blue),
                            _socialIcon(Icons.camera_alt, Colors.pink),
                            _socialIcon(Icons.play_circle, Colors.red),
                            _socialIcon(Icons.close, Colors.black87),
                            _socialIcon(Icons.chat, Colors.green),
                            _socialIcon(Icons.work, Colors.blue),
                            _socialIcon(Icons.send, Colors.lightBlue),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Bottom CTA buttons
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, size: 11, color: Colors.white),
                                SizedBox(width: 4),
                                Text('CALL US NOW',
                                    style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            color: const Color(0xFF25D366),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat, size: 11, color: Colors.white),
                                SizedBox(width: 4),
                                Text('WHATSAPP NOW',
                                    style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
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
          _buildPriceSection(),
        ],
      ),
    );
  }

  // ── Card 2: white bg + network image logo ─────────────────────────────────
  Widget _buildTrendingCard2() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Payment',
                                  style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                          ],
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFCC00)),
                          child: ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=200&q=80',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Text('LOGO',
                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Your Business Name',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const Text('#1platform  for digital business',
                            style: TextStyle(fontSize: 7, color: Colors.grey)),
                        const Text('Brief description of your business comes here',
                            style: TextStyle(fontSize: 7, color: Colors.grey)),
                        const SizedBox(height: 6),
                        _infoRow(Icons.phone, '9518311798', Colors.blue),
                        _infoRow(Icons.email, 'email @yoursite.com', Colors.red),
                        _infoRow(Icons.location_on, '1234, Area, City - 456789', Colors.teal),
                        _infoRow(Icons.person_add, 'Save Contact', Colors.purple),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialIconSmall(Icons.facebook, Colors.blue),
                              _socialIconSmall(Icons.camera_alt, Colors.pink),
                              _socialIconSmall(Icons.play_circle, Colors.red),
                              _socialIconSmall(Icons.close, Colors.black),
                              _socialIconSmall(Icons.work, Colors.blue),
                              _socialIconSmall(Icons.send, Colors.lightBlue),
                              _socialIconSmall(Icons.print, Colors.grey),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Row(children: [
                                Icon(Icons.picture_as_pdf, size: 10, color: Colors.red),
                                SizedBox(width: 2),
                                Text('Download PDF', style: TextStyle(fontSize: 7, color: Colors.white)),
                              ]),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF25D366),
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Row(children: [
                                  Icon(Icons.chat, size: 10, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text('WhatsApp', style: TextStyle(fontSize: 7, color: Colors.white)),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                child: const Row(children: [
                                  Icon(Icons.phone, size: 10, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text('Call Us', style: TextStyle(fontSize: 7, color: Colors.white)),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildPriceSection(),
        ],
      ),
    );
  }

  // ── Card 3: full-bleed portrait image ─────────────────────────────────────
  Widget _buildTrendingCard3() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.50)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: const Center(
                            child: Text('YOUR\nLOGO',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Your Business Name',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('#1 platform for digital business',
                            style: TextStyle(fontSize: 8, color: Colors.white70)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIcon(Icons.facebook, Colors.blue),
                            _socialIcon(Icons.camera_alt, Colors.pink),
                            _socialIcon(Icons.play_circle, Colors.red),
                            _socialIcon(Icons.chat, Colors.green),
                            _socialIcon(Icons.work, Colors.blue),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white38),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.phone, size: 11, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('Call Now',
                                        style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat, size: 11, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('WhatsApp',
                                        style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildPriceSection(),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          const Text('₹ 299.0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(width: 6),
          const Text('₹ 499.0',
              style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('40% OFF',
                style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Promo Banner ──────────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              height: 170,
              width: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A237E)),
              ),
            ),
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            child: Transform.rotate(
                              angle: -0.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 50,
                                  height: 80,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=200&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: const Color(0xFFFFCC00)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 22,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SizedBox(
                                width: 50,
                                height: 80,
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=200&q=80',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: const Color(0xFFE91E63)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 50,
                                  height: 80,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Smart.. Elegant.. Affordable',
                              style: TextStyle(fontSize: 10, color: Colors.white70)),
                          const Text('DIGITAL BUSINESS\nCARD',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2)),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Professional Cards ────────────────────────────────────────────────────
  Widget _buildProfessionalCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildProfCard(
              headerImageUrl:
                  'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=400&q=80',
              avatarUrl:
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildProfCard(
              headerImageUrl:
                  'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
              avatarUrl:
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfCard({required String headerImageUrl, required String avatarUrl}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Stack(
              children: [
                SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: Image.network(
                    headerImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 75,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(height: 75, color: Colors.black.withOpacity(0.35)),
              ],
            ),
          ),
          // Avatar overlapping header
          Transform.translate(
            offset: const Offset(0, -24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 28, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Content
          Transform.translate(
            offset: const Offset(0, -18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Business Name',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const Text('#1 platform for digital business',
                      style: TextStyle(fontSize: 7, color: Colors.grey)),
                  const Text('Brief description of your business comes here',
                      style: TextStyle(fontSize: 7, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _coloredSocialIcon(Icons.facebook, const Color(0xFF1877F2)),
                      _coloredSocialIcon(Icons.chat, const Color(0xFF25D366)),
                      _coloredSocialIcon(Icons.camera_alt, const Color(0xFFE1306C)),
                      _coloredSocialIcon(Icons.diamond, const Color(0xFF00AFF0)),
                      _coloredSocialIcon(Icons.work, const Color(0xFF0A66C2)),
      
                    ],
                  ),
                  const SizedBox(height: 6),
                  _contactRow(Icons.phone, '9518311798', const Color(0xFF25D366)),
                  _contactRow(Icons.email, 'email@yoursite.com', Colors.orange),
                  _contactRow(Icons.location_on, '12-34, Area, City - 456789', Colors.red),
                  _contactRow(Icons.person_add, 'Save Contact', Colors.grey),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _contactRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 10, color: Colors.white),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 8, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _coloredSocialIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 11, color: Colors.white),
      ),
    );
  }

  Widget _miniIconText(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 10, color: Colors.white),
        Text(text, style: const TextStyle(fontSize: 6, color: Colors.white70)),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 9, color: Colors.white),
      ),
    );
  }

  Widget _socialIconSmall(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Icon(icon, size: 10, color: Colors.white),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            child: Icon(icon, size: 9, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 8))),
        ],
      ),
    );
  }
}