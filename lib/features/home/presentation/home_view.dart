import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget _buildRitualButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFeff5f0),
              border: Border.all(
                color: const Color(0xFFbec9c2).withOpacity(0.5),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00523b),
              size: 24.w,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: hpStyles.sb10.copyWith(
              color: const Color(0xFF3f4944),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String imageUrl,
    required String category,
    required String time,
    required String title,
    required String description,
    required Color tagBgColor,
    required Color tagTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFbec9c2).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00523b).withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: hpStyles.sb10.copyWith(
                          color: tagTextColor,
                          fontSize: 9,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: hpStyles.l10.copyWith(
                        color: const Color(0xFF6f7973),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: hpStyles.sb14.copyWith(
                    color: const Color(0xFF171d1a),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: hpStyles.r12.copyWith(
                    color: const Color(0xFF3f4944),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5FBF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF00523b),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              "My Prophecy App",
              style: hpStyles.sb16.copyWith(
                color: const Color(0xFF00523b),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF3f4944),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) +
            const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ~ Hero Alignment Card
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 280.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a6b51),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1a6b51).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Radial Dot Background Pattern
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 20,
                            ),
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Soft glow circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF6600).withOpacity(0.15),
                            // filtersQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      // Moon outline decoration
                      const Positioned(
                        bottom: 16,
                        right: 16,
                        child: Opacity(
                          opacity: 0.08,
                          child: Icon(
                            Icons.dark_mode_rounded,
                            size: 110,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Stars outline decoration
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Opacity(
                          opacity: 0.08,
                          child: Icon(
                            Icons.stars_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Main Content
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFF6600),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "TODAY'S ALIGNMENT",
                                  style: hpStyles.sb10.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '"Your intuition is a compass pointing toward a horizon of unseen opportunities."',
                              style: hpStyles.sb20.copyWith(
                                color: Colors.white,
                                height: 1.35,
                                fontSize: 20,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Reveal More",
                                      style: hpStyles.sb10.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
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
              ],
            ),
            const SizedBox(height: 28),

            // ~ Daily Rituals Section
            Text(
              "Daily Rituals",
              style: hpStyles.sb16.copyWith(
                color: const Color(0xFF171d1a),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRitualButton(
                  context,
                  icon: Icons.style_rounded,
                  label: "Daily Tarot",
                  onTap: () {},
                ),
                _buildRitualButton(
                  context,
                  icon: Icons.brightness_4_rounded,
                  label: "Moon Phase",
                  onTap: () {},
                ),
                _buildRitualButton(
                  context,
                  icon: Icons.self_improvement_rounded,
                  label: "Guided Ritual",
                  onTap: () {},
                ),
                _buildRitualButton(
                  context,
                  icon: Icons.add_circle_outline_rounded,
                  label: "Journal",
                  onTap: () {
                    // Navigate seamlessly to Journey tab index (2) inside our AutoTabsRouter
                    final tabsRouter = AutoTabsRouter.of(context);
                    tabsRouter.setActiveIndex(2);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ~ Celestial Insights Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Celestial Insights",
                  style: hpStyles.sb16.copyWith(
                    color: const Color(0xFF171d1a),
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "View All",
                    style: hpStyles.sb14.copyWith(
                      color: const Color(0xFF00523b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Feed Column
            Column(
              spacing: 12,
              children: [
                _buildInsightCard(
                  imageUrl:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDsD8-EofjGiHn5ESCkc6E-zMUAIrIxu-NSkGou9YfJHIwckSqIox4qt5eq64_cpcMKsxtG_EsLblb6JTvHACmzwA76pdeNhHyQBKR_fMf6LokV7GM2VZoV-YrU4-xQmzo6xOotH55jL07oP_zagx55nqY5A86D9HcX9uSJZhhWKdUELCAQV9mx7SwSxlUmNJnb8Zh0t4TEn52ZpfUAn8w40gBHBdhPUxNVFxyp2Jv66HeS-M2orspTSfkJzrC4MHF5Io7TZpJGQiA",
                  category: "CAREER",
                  time: "2h ago",
                  title: "The Sun in Gemini: Communication Peaks",
                  description:
                      "Your social energies are aligning with Mercury, suggesting it's the perfect time for negotiations...",
                  tagBgColor: const Color(0xFFfeaa85).withOpacity(0.2),
                  tagTextColor: const Color(0xFF793c20),
                ),
                _buildInsightCard(
                  imageUrl:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuD44xbtwGAcuqFi8466EIFCrhBNry4VMeAwuBhbNVMYiTmb2JgY3jqslLECjX_E6yTqfRDWDGDD4PJwgDwaQoG3HioMO27NgkW5NERPUxX6t_fO3-KAq20Ma3Z03jTUyUmRUf-SrXszCZBNwAff-CKfhFl-ucAoc1S2l9gw9-xbo_kvgWQOLM2Zc0NgVtphuUAQqMjkv4_deGC4J87FujvHLwwPP68CFjlLfZGFAeL2EPczcXSqXWerlqeEk8McB0eURVCJvNW9VB8",
                  category: "SPIRIT",
                  time: "5h ago",
                  title: "Evening Rituals for Deep Clarity",
                  description:
                      "Consider lighting a green candle tonight to ground your intentions for the coming lunar cycle...",
                  tagBgColor: const Color(0xFFFFE08B).withOpacity(0.2),
                  tagTextColor: const Color(0xFF4e3d00),
                ),

                // Bento-Style Weekend Forecast Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE5DE).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00523b).withOpacity(0.1),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background decorative snowflake icon
                      const Positioned(
                        bottom: -16,
                        right: -16,
                        child: Opacity(
                          opacity: 0.08,
                          child: Icon(
                            Icons.ac_unit_rounded,
                            size: 80,
                            color: Color(0xFF00523b),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WEEKEND FORECAST",
                            style: hpStyles.sb10.copyWith(
                              color: const Color(0xFF00523b),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Restorative Energies Arriving",
                            style: hpStyles.sb16.copyWith(
                              color: const Color(0xFF171d1a),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "The upcoming transit favors home and family connections. A period of healing and restoration begins on Friday evening as Mars moves into a softer house.",
                            style: hpStyles.r12.copyWith(
                              color: const Color(0xFF3f4944),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Read the full forecast",
                                style: hpStyles.sb12.copyWith(
                                  color: const Color(0xFF00523b),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.open_in_new_rounded,
                                color: Color(0xFF00523b),
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
