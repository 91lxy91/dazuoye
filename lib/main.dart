import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'models/plan.dart';
import 'pages/profile_page.dart';
import 'pages/plan_page.dart';
import 'pages/statistic_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        scaffoldBackgroundColor: AppColors.surface,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: AppColors.cardLight,
        ),
      ),
      home: const MainTabPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;
  late List<Plan> allPlanList;

  @override
  void initState() {
    super.initState();
    allPlanList = [
      Plan(title: '晨跑锻炼', subtitle: '每天 6:30 - 7:30', status: PlanStatus.completed, avatarUrl: 'https://picsum.photos/200/200?random=1'),
      Plan(title: 'Flutter 学习', subtitle: '上午 9:00 - 11:00', status: PlanStatus.completed, avatarUrl: 'https://picsum.photos/200/200?random=2'),
      Plan(title: '午餐 & 休息', subtitle: '中午 12:00 - 13:00', status: PlanStatus.completed, avatarUrl: 'https://picsum.photos/200/200?random=3'),
      Plan(title: '项目开发实战', subtitle: '下午 14:00 - 17:00', status: PlanStatus.inProgress, avatarUrl: 'https://picsum.photos/200/200?random=4'),
      Plan(title: '阅读技术文章', subtitle: '傍晚 17:00 - 18:00', status: PlanStatus.inProgress, avatarUrl: 'https://picsum.photos/200/200?random=5'),
      Plan(title: '晚饭休息', subtitle: '晚上 18:00 - 19:00', status: PlanStatus.notStarted, avatarUrl: 'https://picsum.photos/200/200?random=6'),
      Plan(title: '复习今日内容', subtitle: '晚上 19:00 - 21:00', status: PlanStatus.notStarted, avatarUrl: 'https://picsum.photos/200/200?random=7'),
      Plan(title: '整理明日计划', subtitle: '晚上 21:00 - 22:00', status: PlanStatus.notStarted, avatarUrl: 'https://picsum.photos/200/200?random=8'),
    ];
  }

  void changeTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ProfilePage(parentChangeTab: changeTab),
          PlanPage(sourceList: allPlanList, onUpdate: _updatePlanStatus, onAdd: _addPlan, onEdit: _editPlan, onDelete: _deletePlan),
          StatisticPage(sourceList: allPlanList),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "我的"),
              BottomNavigationBarItem(icon: Icon(Icons.checklist_rounded), label: "计划"),
              BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: "统计"),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePlanStatus(int originalIndex, PlanStatus newStatus) {
    setState(() => allPlanList[originalIndex] = allPlanList[originalIndex].copyWith(status: newStatus));
  }

  void _addPlan(Plan plan) {
    setState(() => allPlanList.insert(0, plan));
  }

  void _editPlan(int index, Plan plan) {
    setState(() => allPlanList[index] = plan);
  }

  void _deletePlan(int index) {
    setState(() => allPlanList.removeAt(index));
  }
}
