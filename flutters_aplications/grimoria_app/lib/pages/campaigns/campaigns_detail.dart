import 'package:flutter/material.dart';
import 'package:grimoria_app/core/theme/app_theme.dart';
import 'package:grimoria_app/models/campaign_model.dart';
import 'package:grimoria_app/models/character_model.dart';
import 'package:grimoria_app/models/user_model.dart';
import 'package:grimoria_app/core/services/auth_service.dart';
import 'package:grimoria_app/core/services/firestore_service.dart';
import 'package:grimoria_app/pages/characters/character_detail.dart';

class CampaignDetailScreen extends StatefulWidget {
  final String campaignId;
  
  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
  });

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _currentUser;
  CampaignModel? _campaign;
  List<CharacterModel> _characters = [];
  bool _isLoading = true;
  bool _isMaster = false;
  bool _isPlayer = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userModel = await _firestoreService.getUserById(user.uid);
        if (userModel != null) {
          setState(() {
            _currentUser = userModel;
          });
          
          // Load campaign
          final campaign = await _firestoreService.getCampaignById(widget.campaignId);
          if (campaign != null) {
            setState(() {
              _campaign = campaign;
              _isMaster = userModel.isMaster && campaign.masterId == userModel.id;
              _isPlayer = campaign.isPlayer(userModel.id);
            });
            
            // Load characters
            final characters = await _firestoreService.getCharactersByCampaign(widget.campaignId);
            setState(() {
              _characters = characters;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showLeaveCampaignDialog() async {
    if (_campaign == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Campanha'),
        content: Text(
          'Tem certeza de que deseja sair da campanha "${_campaign!.title}"? '
          'Você perderá acesso a todos os personagens e progressos relacionados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _leaveCampaign();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  Future<void> _leaveCampaign() async {
    if (_campaign == null || _currentUser == null) return;
    
    try {
      await _firestoreService.removePlayerFromCampaign(
        _campaign!.id,
        _currentUser!.id,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você saiu da campanha com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao sair da campanha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showInvitePlayerDialog() async {
    if (_campaign == null) return;
    
    final _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Convidar Jogador'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email do Jogador',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email é obrigatório';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'O jogador receberá um convite para participar da campanha "${_campaign!.title}"',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              
              Navigator.pop(context);
              await _invitePlayer(_emailController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Convidar'),
          ),
        ],
      ),
    );
  }

  Future<void> _invitePlayer(String email) async {
    if (_campaign == null) return;
    
    try {
      // Find user by email
      final user = await _firestoreService.getUserByEmail(email);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não encontrado com este email'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Check if user is already in the campaign
      if (_campaign!.isPlayer(user.id) || _campaign!.masterId == user.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este usuário já participa da campanha'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      // Add player to campaign
      await _firestoreService.addPlayerToCampaign(_campaign!.id, user.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jogador convidado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the data
        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao convidar jogador: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showStatusDialog() async {
    if (_campaign == null) return;
    
    final List<String> statusOptions = [
      'Empty',
      'Getting Started',
      'Active',
      'Full',
      'Paused',
      'Completed'
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerenciar Status da Campanha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusOptions.map((status) {
            final isSelected = _campaign!.status == status;
            final color = _getStatusColor(status);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _updateCampaignStatus(status);
                },
                selected: isSelected,
                selectedTileColor: Color(int.parse(color.replaceFirst('#', '0xFF'))).withOpacity(0.2),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCampaignStatus(String newStatus) async {
    if (_campaign == null) return;
    
    try {
      final updatedCampaign = _campaign!.updateStatusManually(newStatus);
      await _firestoreService.updateCampaign(updatedCampaign);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status da campanha atualizado para: $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the data
        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getStatusColor(String status) {
    switch (status) {
      case 'Empty':
        return '#FF9800'; // Orange
      case 'Getting Started':
        return '#2196F3'; // Blue
      case 'Active':
        return '#4CAF50'; // Green
      case 'Full':
        return '#F44336'; // Red
      case 'Paused':
        return '#9E9E9E'; // Grey
      case 'Completed':
        return '#673AB7'; // Purple
      default:
        return '#9E9E9E'; // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF1E1E1E),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFE53935),
                          Color(0xFF1E1E1E),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _campaign?.title ?? 'Campanha',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _campaign?.formattedCode ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mestre: ${_campaign?.masterName ?? 'Desconhecido'}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
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
              // Content
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_campaign == null)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Campanha não encontrada',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A campanha que você está procurando não existe ou foi removida.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campaign Info
                        Text(
                          'Informações da Campanha',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: const Color(0xFF1E1E1E),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _campaign!.description,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_campaign!.participantCount} jogadores',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Criada em ${_formatDate(_campaign!.createdAt)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Characters Section
                        Text(
                          'Personagens',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_characters.isEmpty)
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
                              'Nenhum personagem nesta campanha',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _characters.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final character = _characters[index];
                              return _buildCharacterCard(character);
                            },
                          ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        if (_isMaster || _isPlayer)
                          Column(
                            children: [
                              if (_isMaster)
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // TODO: Implement edit campaign navigation
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Edição de campanha em desenvolvimento'),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFE53935),
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Editar Campanha'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _showInvitePlayerDialog();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF4CAF50),
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(Icons.person_add),
                                        label: const Text('Convidar Jogador'),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_isMaster)
                                const SizedBox(height: 16),
                              if (_isMaster)
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          _showStatusDialog();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFFE53935),
                                          side: const BorderSide(color: const Color(0xFFE53935)),
                                        ),
                                        icon: const Icon(Icons.info),
                                        label: const Text('Gerenciar Status'),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_isPlayer)
                                const SizedBox(height: 16),
                              if (_isPlayer)
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _showLeaveCampaignDialog();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  icon: const Icon(Icons.exit_to_app),
                                  label: const Text('Sair da Campanha'),
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
      ),
    );
  }

  Widget _buildCharacterCard(CharacterModel character) {
    final isOwnCharacter = character.userId == _currentUser?.id;
    
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Character Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isOwnCharacter 
                    ? const Color(0xFF4CAF50) 
                    : const Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOwnCharacter ? Icons.person : Icons.group,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            // Character Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isOwnCharacter)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Seu Personagem',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.classRaceDisplay,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'HP: ${character.currentHealth ?? 0}/${character.maxHealth ?? 0}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (character.level != null)
                        Text(
                          'Nível ${character.level}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white60),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterDetailScreen(characterId: character.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Desconhecido';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}