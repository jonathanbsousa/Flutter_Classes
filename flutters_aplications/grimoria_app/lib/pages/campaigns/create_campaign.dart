import 'package:flutter/material.dart';
import 'package:grimoria_app/core/utils/validators.dart';
import 'package:grimoria_app/core/services/auth_service.dart';
import 'package:grimoria_app/core/services/firestore_service.dart';
import 'package:grimoria_app/models/campaign_model.dart';
import 'package:grimoria_app/models/user_model.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isGeneratingCode = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userModel = await _authService.getUserById(user.uid);
        if (userModel != null) {
          setState(() {
            _currentUser = userModel;
          });
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
    }
  }

  Future<void> _generateCode() async {
    setState(() {
      _isGeneratingCode = true;
    });

    try {
      // Gera um código alfanumérico aleatório de 6 caracteres
      final code = _generateRandomCode();
      _codeController.text = code;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar código: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingCode = false;
        });
      }
    }
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';

    for (int i = 0; i < 6; i++) {
      final index = (random + i * 12345) % chars.length;
      code += chars[index];
    }

    return code;
  }

  Future<void> _createCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verifica se o código já existe
      try {
        final existingCampaign = await _firestoreService.getCampaignByCode(
          _codeController.text.toUpperCase(),
        );
        if (existingCampaign != null) {
          throw Exception('Este código já está em uso. Por favor, gere outro.');
        }
      } catch (_) {
        // Ignora erro se for apenas "não encontrado"
      }

      final campaign = CampaignModel(
        id: '', // O ID será gerado pelo Firestore
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        code: _codeController.text.trim().toUpperCase(),
        masterId: user.uid,
        masterName: _currentUser?.name ?? 'Mestre Desconhecido',
        playerIds: [],
        characterIds: [], // Adicionado para corrigir o erro
        status: 'Empty',
        statusColor: '#FF9800',
        createdAt: DateTime.now()
      );

      await _firestoreService.createCampaign(campaign);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campanha criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Retorna true para indicar que uma campanha foi criada (para atualizar a lista anterior)
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar campanha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- Header com Gradiente ---
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
                        Color(0xFFE53935), // Vermelho RPG
                        Color(0xFF1E1E1E), // Fundo Dark
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
                            Text(
                              'Criar Nova Campanha',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Como mestre, você pode criar campanhas e convidar jogadores',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Conteúdo do Formulário ---
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da Seção
                      Text(
                        'Informações da Campanha',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Título
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Título da Campanha',
                          hintText: 'Ex: A Jornada do Herói',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: Validators.validateCampaignTitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),

                      // Campo Descrição
                      TextFormField(
                        controller: _descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Descrição da Campanha',
                          hintText:
                              'Descreva a história, o mundo e os objetivos...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: Validators.validateCampaignDescription,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),

                      // Seção Código
                      Text(
                        'Código da Campanha',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Código + Botão Gerar
                      TextFormField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'Código Único',
                          hintText: 'Código de 6 caracteres',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.vpn_key),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Mostra preview do código
                              if (_codeController.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    _codeController.text.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFFE53935),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              // Botão Refresh/Loading
                              _isGeneratingCode
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.refresh),
                                      color: Colors.white60,
                                      onPressed: _generateCode,
                                      tooltip: "Gerar novo código",
                                    ),
                            ],
                          ),
                        ),
                        validator: Validators.validateCampaignCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Este código será usado pelos jogadores para entrar na sua campanha.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                      ),
                      const SizedBox(height: 32),

                      // Botão Criar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createCampaign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Criar Campanha',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dicas (Tips)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE53935).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: Color(0xFFE53935),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Dicas para criar uma boa campanha',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '• Crie um código fácil de lembrar e compartilhar\n'
                              '• Descreva claramente o tipo de aventura esperada\n'
                              '• Defina regras básicas e estilo de jogo\n'
                              '• Prepare-se para adaptar a história conforme os jogadores evoluem',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Espaço extra no final para scroll
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
