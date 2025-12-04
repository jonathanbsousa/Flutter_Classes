import 'package:flutter/material.dart';
import 'package:grimoria_app/core/theme/app_theme.dart';
import 'package:grimoria_app/models/campaign_model.dart';
import 'package:grimoria_app/models/user_model.dart';
import 'package:grimoria_app/core/services/auth_service.dart';
import 'package:grimoria_app/core/services/firestore_service.dart';
import 'package:grimoria_app/pages/campaigns/campaigns_detail.dart';

class CampaignsListScreen extends StatefulWidget {
  const CampaignsListScreen({super.key});

  @override
  State<CampaignsListScreen> createState() => _CampaignsListScreenState();
}

class _CampaignsListScreenState extends State<CampaignsListScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _currentUser;
  List<CampaignModel> _campaigns = [];
  bool _isLoading = true;
  int _selectedFilter = 0; // 0: All, 1: Master, 2: Player

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userModel = await _firestoreService.getUserById(user.uid);
        if (userModel != null) {
          setState(() {
            _currentUser = userModel;
          });
          await _loadCampaigns();
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

  Future<void> _loadCampaigns() async {
    try {
      List<CampaignModel> campaigns = [];
      
      switch (_selectedFilter) {
        case 0: // All
          if (_currentUser?.isMaster == true) {
            campaigns = await _firestoreService.getCampaignsByMaster(_currentUser!.id);
          } else {
            campaigns = await _firestoreService.getCampaignsByPlayer(_currentUser!.id);
          }
          break;
        case 1: // Master
          if (_currentUser?.isMaster == true) {
            campaigns = await _firestoreService.getCampaignsByMaster(_currentUser!.id);
          }
          break;
        case 2: // Player
          campaigns = await _firestoreService.getCampaignsByPlayer(_currentUser!.id);
          break;
      }

      setState(() {
        _campaigns = campaigns;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar campanhas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _joinCampaign(CampaignModel campaign) async {
    if (_currentUser == null) return;
    
    try {
      // Check if user is already in the campaign
      if (campaign.isPlayer(_currentUser!.id) || campaign.isMaster(_currentUser!.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já participa desta campanha!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Add player to campaign
      await _firestoreService.addPlayerToCampaign(campaign.id, _currentUser!.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você ingressou na campanha com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the campaigns list
        await _loadCampaigns();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao ingressar na campanha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserData,
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
                        'Campanhas',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(0, 'Todas', Icons.all_inclusive),
                            const SizedBox(width: 8),
                            if (_currentUser?.isMaster == true)
                              _buildFilterChip(1, 'Como Mestre', Icons.admin_panel_settings),
                            const SizedBox(width: 8),
                            _buildFilterChip(2, 'Como Jogador', Icons.person),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Campaigns List
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else if (_campaigns.isEmpty)
                        _buildEmptyState()
                      else
                        _buildCampaignsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentUser?.isMaster == true
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-campaign');
              },
              backgroundColor: const Color(0xFFE53935),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFilterChip(int index, String label, IconData icon) {
    final isSelected = _selectedFilter == index;
    
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white60,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      backgroundColor: isSelected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
      onPressed: () {
        setState(() {
          _selectedFilter = index;
        });
        _loadCampaigns();
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.campaign_outlined,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateTitle(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white60,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentUser?.isMaster == true && _selectedFilter == 1)
            const SizedBox(height: 24),
          if (_currentUser?.isMaster == true && _selectedFilter == 1)
            ElevatedButton(
              onPressed: () {
                // Navigate to create campaign
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
              ),
              child: const Text('Criar Primeira Campanha'),
            ),
        ],
      ),
    );
  }

  String _getEmptyStateTitle() {
    switch (_selectedFilter) {
      case 0:
        return 'Nenhuma campanha encontrada';
      case 1:
        return 'Nenhuma campanha como mestre';
      case 2:
        return 'Nenhuma campanha como jogador';
      default:
        return 'Nenhuma campanha encontrada';
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 0:
        return _currentUser?.isMaster == true
            ? 'Você não participa de nenhuma campanha no momento. Crie uma nova campanha ou aguarde convites.'
            : 'Você não participa de nenhuma campanha no momento. Peça a um mestre para te convidar.';
      case 1:
        return 'Crie sua primeira campanha como mestre e comece a aventura!';
      case 2:
        return 'Peça a um mestre para te convidar para uma campanha ou aguarde novos convites.';
      default:
        return 'Nenhuma campanha encontrada.';
    }
  }

  Widget _buildCampaignsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _campaigns.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final campaign = _campaigns[index];
        return _buildCampaignCard(campaign);
      },
    );
  }

  Widget _buildCampaignCard(CampaignModel campaign) {
    final isMaster = _currentUser?.isMaster == true && campaign.isMaster(_currentUser!.id);
    final isPlayer = campaign.isPlayer(_currentUser!.id);
    
    return Card(
      color: const Color(0xFF1E1E1E),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampaignDetailScreen(campaignId: campaign.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(int.parse(campaign.statusColor.replaceFirst('#', '0xFF')))
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                campaign.status,
                                style: TextStyle(
                                  color: Color(int.parse(campaign.statusColor.replaceFirst('#', '0xFF'))),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isMaster)
                              Icon(
                                Icons.admin_panel_settings,
                                color: const Color(0xFFE53935),
                                size: 16,
                              ),
                            if (isPlayer)
                              Icon(
                                Icons.person,
                                color: const Color(0xFF4CAF50),
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          campaign.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          campaign.formattedCode,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isMaster && !isPlayer)
                    IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF4CAF50)),
                      onPressed: () => _joinCampaign(campaign),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white60),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampaignDetailScreen(campaignId: campaign.id),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Campaign Description
              Text(
                campaign.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Campaign Info
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${campaign.participantCount} jogadores',
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
                    'Mestre: ${campaign.masterName}',
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
    );
  }
}