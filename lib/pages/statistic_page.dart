import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/plan.dart';

class StatisticPage extends StatefulWidget {
  final List<Plan> sourceList;
  final VoidCallback toggleTheme;
  final bool isDark;
  const StatisticPage({super.key, required this.sourceList, required this.toggleTheme, required this.isDark});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    final total = widget.sourceList.length;
    final comp = widget.sourceList.where((e) => e.status == PlanStatus.completed).length;
    final prog = widget.sourceList.where((e) => e.status == PlanStatus.inProgress).length;
    final wait = widget.sourceList.where((e) => e.status == PlanStatus.notStarted).length;
    final rate = total == 0 ? 0.0 : comp / total;
    final cardBg = AppColors.cardBg(context);
    final textPri = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.gradientTop, AppColors.gradientBottom]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        title: const Text('数据统计'),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            onPressed: widget.toggleTheme,
            tooltip: widget.isDark ? '切换浅色模式' : '切换深色模式',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRateCard(rate, comp, total, cardBg, textPri, textSec),
            const SizedBox(height: 16),
            _buildStatRow(comp, prog, wait, cardBg, textSec),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('计划明细', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPri)),
            ),
            const SizedBox(height: 14),
            ...widget.sourceList.asMap().entries.map((e) => _buildPlanItem(e.key, e.value, cardBg, textSec)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard(double rate, int comp, int total, Color cardBg, Color textPri, Color textSec) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Text('计划完成率', style: TextStyle(fontSize: 15, color: textSec, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          SizedBox(
            width: 140, height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140, height: 140,
                  child: CircularProgressIndicator(
                    value: rate, strokeWidth: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(rate * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    Text('$comp/$total', style: TextStyle(fontSize: 13, color: textSec)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('已完成 $comp 项，继续加油！', style: TextStyle(fontSize: 14, color: textSec)),
        ],
      ),
    );
  }

  Widget _buildStatRow(int comp, int prog, int wait, Color cardBg, Color textSec) {
    return Row(
      children: [
        Expanded(child: _statCard('已完成', comp, const Color(0xFF4CAF50), Icons.task_alt_rounded, cardBg, textSec)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('进行中', prog, const Color(0xFF2196F3), Icons.play_circle_rounded, cardBg, textSec)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('未开始', wait, const Color(0xFFFF9800), Icons.pending_rounded, cardBg, textSec)),
      ],
    );
  }

  Widget _statCard(String label, int num, Color color, IconData icon, Color cardBg, Color textSec) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text('$num', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: textSec)),
        ],
      ),
    );
  }

  Widget _buildPlanItem(int idx, Plan p, Color cardBg, Color textSec) {
    final color = p.status == PlanStatus.completed
        ? const Color(0xFF4CAF50)
        : p.status == PlanStatus.inProgress
        ? const Color(0xFF2196F3)
        : const Color(0xFFFF9800);
    final icon = p.status == PlanStatus.completed
        ? Icons.check_circle_rounded
        : p.status == PlanStatus.inProgress
        ? Icons.play_circle_rounded
        : Icons.radio_button_unchecked_rounded;
    final txt = p.status == PlanStatus.completed ? '已完成' : p.status == PlanStatus.inProgress ? '进行中' : '未开始';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('${idx + 1}', style: TextStyle(color: color, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(p.subtitle, style: TextStyle(fontSize: 12, color: textSec)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Text(txt, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
