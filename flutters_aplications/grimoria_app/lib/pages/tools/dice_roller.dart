import 'package:flutter/material.dart';
import 'package:grimoria_app/core/theme/app_theme.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> with TickerProviderStateMixin {
  late AnimationController _diceAnimationController;
  late Animation<double> _diceAnimation;
  
  int _diceValue = 1;
  int _diceType = 20;
  int _rollCount = 0;
  List<int> _rollHistory = [];
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _diceAnimation = CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;
    
    setState(() {
      _isRolling = true;
      _rollCount++;
    });
    
    _diceAnimationController.forward().then((_) {
      setState(() {
        _diceValue = _generateRandomNumber(_diceType);
        _rollHistory.insert(0, _diceValue);
        if (_rollHistory.length > 10) {
          _rollHistory.removeLast();
        }
        _isRolling = false;
      });
      _diceAnimationController.reset();
    });
  }

  int _generateRandomNumber(int max) {
    return 1 + (DateTime.now().millisecondsSinceEpoch % max);
  }

  String _getDiceResultText() {
    if (_diceType == 20) {
      if (_diceValue == 20) return 'CRÍTICO! 🎯';
      if (_diceValue == 1) return 'FALHA! 💀';
      return 'Resultado: $_diceValue';
    }
    return 'Resultado: $_diceValue';
  }

  Color _getDiceResultColor() {
    if (_diceType == 20) {
      if (_diceValue == 20) return Colors.green;
      if (_diceValue == 1) return Colors.red;
      return Colors.white;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E1E1E),
                      Color(0xFF121212),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ferramentas RPG',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dado Virtual e outras ferramentas úteis',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dice Roller Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dado Virtual',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Dice Display
                    Center(
                      child: GestureDetector(
                        onTap: _rollDice,
                        child: AnimatedBuilder(
                          animation: _diceAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _diceAnimation.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE53935),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Dice dots pattern
                                    _buildDiceDots(_diceValue),
                                    // Rolling indicator
                                    if (_isRolling)
                                      const Positioned.fill(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Result Text
                    Center(
                      child: Text(
                        _getDiceResultText(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _getDiceResultColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Dice Type Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDiceTypeButton(4, 'D4'),
                        const SizedBox(width: 12),
                        _buildDiceTypeButton(6, 'D6'),
                        const SizedBox(width: 12),
                        _buildDiceTypeButton(8, 'D8'),
                        const SizedBox(width: 12),
                        _buildDiceTypeButton(10, 'D10'),
                        const SizedBox(width: 12),
                        _buildDiceTypeButton(12, 'D12'),
                        const SizedBox(width: 12),
                        _buildDiceTypeButton(20, 'D20'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Roll Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _rollDice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isRolling ? 'Rolando...' : 'Rolar Dado',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Roll History
                    Text(
                      'Histórico de Rolagens',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_rollHistory.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Nenhuma rolagem ainda',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(_rollHistory.length, (index) {
                            final roll = _rollHistory[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '#${_rollCount - index}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Rolou D$_diceType: $roll',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_diceType == 20 && (roll == 20 || roll == 1))
                                    Icon(
                                      roll == 20 ? Icons.star : Icons.warning,
                                      color: roll == 20 ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Additional Tools Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próximas Ferramentas',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildToolCard(
                          icon: Icons.calculate,
                          title: 'Calculadora',
                          subtitle: 'Calculadora de bônus e penalidades',
                          onTap: () {},
                        ),
                        _buildToolCard(
                          icon: Icons.table_chart,
                          title: 'Tabela de Dados',
                          subtitle: 'Tabelas de referência rápida',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tabela de dados em desenvolvimento'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        ),
                        _buildToolCard(
                          icon: Icons.note_alt,
                          title: 'Notas Rápidas',
                          subtitle: 'Anote ideias e informações',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notas rápidas em desenvolvimento'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        ),
                        _buildToolCard(
                          icon: Icons.timer,
                          title: 'Temporizador',
                          subtitle: 'Temporizador para sessões',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Temporizador em desenvolvimento'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceDots(int value) {
    final List<Widget> dots = [];
    
    // Define dot positions for each dice value
    final positions = {
      1: [[0.5, 0.5]],
      2: [[0.25, 0.25], [0.75, 0.75]],
      3: [[0.25, 0.25], [0.5, 0.5], [0.75, 0.75]],
      4: [[0.25, 0.25], [0.75, 0.25], [0.25, 0.75], [0.75, 0.75]],
      5: [[0.25, 0.25], [0.75, 0.25], [0.5, 0.5], [0.25, 0.75], [0.75, 0.75]],
      6: [[0.25, 0.25], [0.75, 0.25], [0.25, 0.5], [0.75, 0.5], [0.25, 0.75], [0.75, 0.75]],
    };
    
    if (positions.containsKey(value)) {
      for (final pos in positions[value]!) {
        dots.add(
          Positioned(
            left: (pos[0]! - 0.1) * MediaQuery.of(context).size.width,
            top: (pos[1]! - 0.1) * MediaQuery.of(context).size.height,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }
    }
    
    return Stack(children: dots);
  }

  Widget _buildDiceTypeButton(int sides, String label) {
    final isSelected = _diceType == sides;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _diceType = sides;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFFE53935),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
