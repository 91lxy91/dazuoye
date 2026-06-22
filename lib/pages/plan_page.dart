import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/plan.dart';
import 'game_page.dart';

class PlanPage extends StatefulWidget {
  final List<Plan> sourceList;
  final Function(int, PlanStatus) onUpdate;
  final Function(Plan) onAdd;
  final Function(int, Plan) onEdit;
  final Function(int) onDelete;
  const PlanPage({super.key, required this.sourceList, required this.onUpdate, required this.onAdd, required this.onEdit, required this.onDelete});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  FilterStatus selectedFilter = FilterStatus.all;
  late List<Plan> showList;
  late List<int> indexMap;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    refreshFilter();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Plan> get _filteredList {
    if (_searchQuery.isEmpty) return showList;
    return showList.where((p) =>
      p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.subtitle.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void refreshFilter() {
    switch (selectedFilter) {
      case FilterStatus.all:
        showList = List.from(widget.sourceList);
        indexMap = List.generate(widget.sourceList.length, (i) => i);
      case FilterStatus.completed:
        showList = []; indexMap = [];
        for (var i = 0; i < widget.sourceList.length; i++) {
          if (widget.sourceList[i].status == PlanStatus.completed) { showList.add(widget.sourceList[i]); indexMap.add(i); }
        }
      case FilterStatus.inProgress:
        showList = []; indexMap = [];
        for (var i = 0; i < widget.sourceList.length; i++) {
          if (widget.sourceList[i].status == PlanStatus.inProgress) { showList.add(widget.sourceList[i]); indexMap.add(i); }
        }
      case FilterStatus.notStarted:
        showList = []; indexMap = [];
        for (var i = 0; i < widget.sourceList.length; i++) {
          if (widget.sourceList[i].status == PlanStatus.notStarted) { showList.add(widget.sourceList[i]); indexMap.add(i); }
        }
    }
  }

  void _showPlanDialog({int? editIndex, Plan? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final subCtrl = TextEditingController(text: existing?.subtitle ?? '');
    final isEdit = existing != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? '编辑计划' : '新增计划', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: '计划名称', hintText: '例如：晨跑锻炼',
                prefixIcon: Icon(Icons.title_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: subCtrl,
              decoration: const InputDecoration(
                labelText: '时间安排', hintText: '例如：每天 6:30 - 7:30',
                prefixIcon: Icon(Icons.access_time_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final subtitle = subCtrl.text.trim();
              if (title.isEmpty) return;
              final newPlan = Plan(
                title: title, subtitle: subtitle,
                status: existing?.status ?? PlanStatus.notStarted,
                avatarUrl: 'https://picsum.photos/200/200?random=${DateTime.now().millisecond}',
              );
              if (isEdit && editIndex != null) {
                widget.onEdit(editIndex, newPlan);
              } else {
                widget.onAdd(newPlan);
              }
              Navigator.pop(ctx);
              setState(() => refreshFilter());
            },
            child: Text(isEdit ? '保存修改' : '添 加'),
          ),
        ],
      ),
    );
  }

  void showStatusSheet(int displayIndex) {
    final originIndex = indexMap[displayIndex];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('修改计划状态', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            const SizedBox(height: 24),
            _statusOption(Icons.check_circle_rounded, '已完成', const Color(0xFF4CAF50), () {
              widget.onUpdate(originIndex, PlanStatus.completed);
              Navigator.pop(context); setState(() => refreshFilter());
            }),
            _statusOption(Icons.play_circle_rounded, '进行中', const Color(0xFF2196F3), () {
              widget.onUpdate(originIndex, PlanStatus.inProgress);
              Navigator.pop(context); setState(() => refreshFilter());
            }),
            _statusOption(Icons.radio_button_unchecked_rounded, '未开始', const Color(0xFFFF9800), () {
              widget.onUpdate(originIndex, PlanStatus.notStarted);
              Navigator.pop(context); setState(() => refreshFilter());
            }),
            const Divider(height: 20),
            _statusOption(Icons.delete_outline_rounded, '删除计划', Colors.red, () {
              widget.onDelete(originIndex);
              Navigator.pop(context); setState(() => refreshFilter());
            }),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(IconData icon, String text, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: color.withValues(alpha: 0.06),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.surface(context);
    final cardBg = AppColors.cardBg(context);
    final textPri = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.gradientTop, AppColors.gradientBottom]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        title: const Text('我的计划表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sports_esports_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GamePage())),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientTop, AppColors.gradientBottom]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.checklist_rounded, color: Colors.white)),
                  SizedBox(height: 12),
                  Text('我的计划表', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _drawerItem(Icons.check_circle_rounded, '已完成', Colors.green, FilterStatus.completed),
            _drawerItem(Icons.play_circle_rounded, '进行中', Colors.blue, FilterStatus.inProgress),
            _drawerItem(Icons.radio_button_unchecked_rounded, '未开始', Colors.orange, FilterStatus.notStarted),
            const Divider(indent: 16, endIndent: 16),
            _drawerItem(Icons.format_list_bulleted_rounded, '全部计划', AppColors.primary, FilterStatus.all),
          ],
        ),
      ),
      body: Column(
        children: [
          // ---- 搜索栏 ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: InputDecoration(
                hintText: '搜索计划...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _filteredList.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('暂无计划', style: TextStyle(fontSize: 16, color: textSec)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredList.length,
              itemBuilder: (_, i) {
                final p = _filteredList[i];
                final color = _statusColor(p.status);
                return GestureDetector(
                  onTap: () => showStatusSheet(i),
                  onLongPress: () => _showPlanDialog(editIndex: indexMap[i], existing: showList[i]),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border(left: BorderSide(color: color, width: 4)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(p.avatarUrl, width: 56, height: 56, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 56, height: 56, color: color.withValues(alpha: 0.1),
                                child: Icon(Icons.task_alt_rounded, color: color, size: 24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPri)),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[400]),
                                const SizedBox(width: 4),
                                Text(p.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                              ]),
                            ],
                          ),
                        ),
                        _statusBadge(p.status),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          onPressed: () => _showPlanDialog(),
          icon: const Icon(Icons.add_rounded),
          label: const Text('新增计划'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _drawerItem(IconData icon, String title, Color color, FilterStatus f) {
    final count = f == FilterStatus.all
        ? widget.sourceList.length
        : widget.sourceList.where((e) => e.status.index == f.index - 1).length;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: () {
        setState(() { selectedFilter = f; refreshFilter(); });
        Navigator.pop(context);
      },
    );
  }

  Color _statusColor(PlanStatus s) {
    switch (s) {
      case PlanStatus.completed: return const Color(0xFF4CAF50);
      case PlanStatus.inProgress: return const Color(0xFF2196F3);
      case PlanStatus.notStarted: return const Color(0xFFFF9800);
    }
  }

  Widget _statusBadge(PlanStatus s) {
    late Color color; late String text; late IconData icon;
    switch (s) {
      case PlanStatus.completed:
        color = const Color(0xFF4CAF50); text = '已完成'; icon = Icons.check_circle_rounded;
      case PlanStatus.inProgress:
        color = const Color(0xFF2196F3); text = '进行中'; icon = Icons.play_circle_rounded;
      case PlanStatus.notStarted:
        color = const Color(0xFFFF9800); text = '未开始'; icon = Icons.radio_button_unchecked_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
