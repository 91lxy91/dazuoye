import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../models/ball.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int _gameDuration = 30;
  int _timeLeft = _gameDuration;
  int _score = 0;
  bool _isPlaying = false;
  bool _gameOver = false;
  Timer? _timer;
  final List<Ball> _balls = [];
  final Random _random = Random();
  final GlobalKey _gameAreaKey = GlobalKey();
  List<int> _history = [];
  int _ballIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('game_history') ?? [];
    setState(() => _history = raw.map((e) => int.parse(e)).toList());
  }

  Future<void> _saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    _history.insert(0, score);
    if (_history.length > 20) _history = _history.sublist(0, 20);
    await prefs.setStringList('game_history', _history.map((e) => e.toString()).toList());
    setState(() {});
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = _gameDuration;
      _isPlaying = true;
      _gameOver = false;
      _balls.clear();
      _ballIdCounter = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _endGame();
      });
    });

    for (int i = 0; i < 5; i++) {
      _spawnBall();
    }
  }

  void _spawnBall() {
    if (!mounted) return;
    final renderBox = _gameAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    if (size.width < 40 || size.height < 40) return;

    const ballSize = 48.0;
    final x = 10.0 + _random.nextDouble() * (size.width - ballSize - 20);
    final y = 10.0 + _random.nextDouble() * (size.height - ballSize - 20);

    final colors = const [
      Color(0xFFFF6B6B), Color(0xFFFFD93D), Color(0xFF6BCB77),
      Color(0xFF4D96FF), Color(0xFF9B59B6), Color(0xFFFF8C00),
    ];

    setState(() {
      _balls.add(Ball(x: x, y: y, color: colors[_random.nextInt(colors.length)], id: _ballIdCounter++));
      if (_balls.length > 12) _balls.removeAt(0);
    });
  }

  void _popBall(int id) {
    setState(() {
      _balls.removeWhere((b) => b.id == id);
      _score++;
    });
    if (_isPlaying) _spawnBall();
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _gameOver = true;
      _balls.clear();
    });
    _saveScore(_score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.gradientTop, AppColors.gradientBottom]),
          ),
        ),
        title: const Text('定位训练'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildTopBar(),
          _buildGameArea(),
          _buildHistory(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoBlock(Icons.timer_rounded, '$_timeLeft s', _timeLeft <= 5 ? Colors.red : AppColors.primary),
          _infoBlock(Icons.stars_rounded, '$_score 分', AppColors.accent),
          GestureDetector(
            onTap: _isPlaying ? null : _startGame,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: _isPlaying ? null : const LinearGradient(colors: [AppColors.gradientTop, AppColors.gradientBottom]),
                color: _isPlaying ? Colors.grey[200] : null,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                _isPlaying ? '游戏中...' : _gameOver ? '再来一局' : '开始游戏',
                style: TextStyle(color: _isPlaying ? Colors.grey : Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return Expanded(
      child: Container(
        key: _gameAreaKey,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              if (!_isPlaying && !_gameOver)
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sports_esports_rounded, size: 64, color: Color(0xFFDDDDF5)),
                      SizedBox(height: 12),
                      Text('点击"开始游戏"按钮', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                      SizedBox(height: 4),
                      Text('30秒内点击小球得分！', style: TextStyle(fontSize: 13, color: Color(0xFFBBBBD5))),
                    ],
                  ),
                ),
              if (_gameOver)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.celebration_rounded, size: 64, color: AppColors.accent),
                      const SizedBox(height: 12),
                      Text('游戏结束！得分: $_score',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      const Text('点击上方"再来一局"继续挑战', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ..._balls.map((ball) => Positioned(
                left: ball.x, top: ball.y,
                child: GestureDetector(
                  onTap: () => _popBall(ball.id),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ball.color,
                      boxShadow: [BoxShadow(color: ball.color.withValues(alpha: 0.5), blurRadius: 12)],
                    ),
                    child: const Icon(Icons.circle, color: Colors.white24, size: 20),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.history_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('历史记录', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 12),
          _history.isEmpty
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('暂无记录，快来挑战吧！', style: TextStyle(color: AppColors.textSecondary))),
          )
              : SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final s = _history[i];
                final best = _history.isEmpty ? 0 : _history.reduce(max);
                final isBest = i == 0 && s == best;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isBest ? AppColors.accent.withValues(alpha: 0.08) : AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: isBest ? Border.all(color: AppColors.accent.withValues(alpha: 0.3)) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$s', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,
                        color: isBest ? AppColors.accent : AppColors.primary,
                      )),
                      if (isBest) const Text('🏆 最佳', style: TextStyle(fontSize: 10, color: AppColors.accent)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
