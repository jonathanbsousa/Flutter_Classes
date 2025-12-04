class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O email é obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'O nome é obrigatório';
    }
    if (value.length < 3) {
      return 'O nome deve ter no mínimo 3 caracteres';
    }
    return null;
  }

  static String? validateCampaignTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'O título da campanha é obrigatório';
    }
    if (value.length < 3) {
      return 'O título deve ter no mínimo 3 caracteres';
    }
    return null;
  }

  static String? validateCampaignDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'A descrição da campanha é obrigatória';
    }
    if (value.length < 10) {
      return 'A descrição deve ter no mínimo 10 caracteres';
    }
    return null;
  }

  static String? validateCampaignCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'O código da campanha é obrigatório';
    }
    if (value.length != 6) {
      return 'O código deve ter exatamente 6 caracteres';
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value.toUpperCase())) {
      return 'O código deve conter apenas letras e números';
    }
    return null;
  }
}