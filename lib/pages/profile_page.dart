import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final Function(int) parentChangeTab;
  const ProfilePage({super.key, required this.parentChangeTab});

  final List<String> tags = const ['Flutter', 'Dart', '编程', '摄影', '旅行', '音乐', '美食', '运动'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildButtons(context),
          const SizedBox(height: 28),
          _buildTags(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12)],
            ),
            child: ClipOval(
              child: Image.network(
                'https://www.helloimg.com/i/2026/04/29/69f15e2a2fdb3.png',
                width: 110, height: 110, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110, height: 110, color: Colors.white24,
                  child: const Icon(Icons.person, color: Colors.white, size: 50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('LXY', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Flutter 开发者', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoChip(Icons.phone_rounded, '888xxxx8888'),
              const SizedBox(width: 20),
              _infoChip(Icons.email_rounded, '781391@stpt.edu.cn'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _gradientBtn('关 注', AppColors.primary, AppColors.primaryDark, () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Row(children: [
                  Icon(Icons.favorite_rounded, color: AppColors.accent),
                  SizedBox(width: 8),
                  Text('感谢关注！', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                content: const Text('谢谢你关注了我！\n\n我会继续努力更新更多精彩内容，敬请期待～'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('好的')),
                ],
              ),
            );
          })),
          const SizedBox(width: 14),
          Expanded(child: _gradientBtn('查看计划', AppColors.accent, const Color(0xFFE55A5A), () => parentChangeTab(1))),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        alignment: WrapAlignment.center, spacing: 10, runSpacing: 10,
        children: tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primaryLight.withValues(alpha: 0.12)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Text(t, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
        )).toList(),
      ),
    );
  }

  Widget _gradientBtn(String text, Color start, Color end, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [start, end]),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: start.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2)),
        ),
      ),
    );
  }
}
